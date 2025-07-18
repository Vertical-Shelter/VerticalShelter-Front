import 'dart:io';

import 'package:app/Vertical-Tracking/Wall/wallController.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/core/app_export.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class VideoCapture extends StatefulWidget {
  String id;
  VideoPlayerController? controller;
  File? file;
  String? url;
  bool isReadOnly;
  bool isRouteSetter;
  bool wantKeepAlive;
  VideoCapture(this.id,
      {this.controller,
      this.isReadOnly = false,
      this.wantKeepAlive = false,
      this.isRouteSetter = false});
  @override
  State<VideoCapture> createState() => _VideoCaptureState();
}

class _VideoCaptureState extends State<VideoCapture>
    with AutomaticKeepAliveClientMixin {
  final ImagePicker _picker = ImagePicker();
  final _instagramUrlController = TextEditingController();
  VideoPlayerController? _controller;
  String thumbnailUrl = "";
  bool isValidUrl = true;
  bool isCaptured = false;
  bool isLink = false;
  bool isReadOnly = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    if (_controller != null) {
      isCaptured = true;
      _controller!.initialize().then((value) => setState(() {}));
    }
    isReadOnly = widget.isReadOnly;
    _initializeThumbnail();
  }

  Future<void> _initializeThumbnail() async {
    await _playURL();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isReadOnly && !isLink) {
      return _previewVideo();
    }

    if (isLink ||
        (widget.controller != null &&
            _isValidInstagramUrl(widget.controller!.dataSource))) {
      return _previewUrl();
    }

    return _controller == null
        ? bodyWhenControllerIsNull()
        : bodyWhenControllerIsNotNull();
  }

  Widget bodyWhenControllerIsNull() {
    return InkWell(
        onTap: () async {
          await popupChooseVideo();
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSurface,
                size: width * 0.05,
              ),
              Text(
                AppLocalizations.of(context)!.ajouter_une_video,
              )
            ],
          ),
        ));
  }

  Widget bodyWhenControllerIsNotNull() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _previewVideo(),
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Row(children: [
                  Icon(
                    Icons.edit,
                    size: width * 0.05,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(width: 5),
                  Text(AppLocalizations.of(context)!.modifier_ma_video,
                      style: Theme.of(context).textTheme.bodyMedium!)
                ]),
                onPressed: () async {
                  await popupChooseVideo();
                },
              )
            ]),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Impossible d\'ouvrir l\'URL : $url';
    }
  }

  Widget _previewUrl() {
    return FutureBuilder(
      future: _playURL(), // Appelle la fonction pour charger les métadonnées
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Erreur de chargement de l'URL");
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Center(
                child: GestureDetector(
                  onTap: () => _launchURL(_instagramUrlController.text),
                  child: thumbnailUrl.isNotEmpty
                      ? Image.network(
                          thumbnailUrl,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Row(children: [
                      Icon(
                        Icons.edit,
                        size: width * 0.05,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      SizedBox(width: 5),
                      Text(AppLocalizations.of(context)!.modifier_ma_video,
                          style: Theme.of(context).textTheme.bodyMedium!)
                    ]),
                    onPressed: () async {
                      await popupChooseVideo();
                    },
                  )
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _previewVideo() {
    return InkWell(
      child: FittedBox(
          child: SizedBox(
              height: _controller!.value.size.height > 0
                  ? _controller!.value.size.height
                  : 1,
              width: _controller!.value.size.width > 0
                  ? _controller!.value.size.width
                  : 1,
              child: VideoPlayer(_controller!))),
      onTap: () async {
        await showDialogVideo();
      },
    );
  }

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      // Libère le contrôleur précédent s'il existe
      await _disposeVideoController();
      late VideoPlayerController controller;

      try {
        // Détermine si le fichier est une URL ou un fichier local
        if (file.path.startsWith('http') || file.path.startsWith('https')) {
          FileInfo? cachedFile =
              await DefaultCacheManager().getFileFromCache(file.path);
          File cachedOrDownloadedFile;

          if (cachedFile != null) {
            cachedOrDownloadedFile = cachedFile.file;
          } else {
            cachedOrDownloadedFile =
                await DefaultCacheManager().getSingleFile(file.path);
          }

          controller = VideoPlayerController.file(cachedOrDownloadedFile);
        } else {
          controller = VideoPlayerController.file(File(file.path));
        }

        _controller = controller;
        // In web, most browsers won't honor a programmatic call to .play
        // if the video has a sound track (and is not muted).
        // Mute the video so it auto-plays in web!
        // This is not needed if the call to .play is the result of user
        // interaction (clicking on a "play" button, for example).

        await controller.setVolume(0);
        await controller.initialize();
        await controller.setLooping(false);
        await controller.play();
        setState(() {});
      } catch (e) {
        // Gestion des erreurs
        print("Erreur lors de la lecture de la vidéo : $e");
      }
    }
    // if (file != null && mounted) {
    //   await _disposeVideoController();
    //   late VideoPlayerController controller;
    //   /*if (kIsWeb) {
    //     controller = VideoPlayerController.network(file.path);
    //   } else {*/
    // FileInfo? cachedFile = await DefaultCacheManager().getFileFromCache(file.path);
    // File cachedOrDownloadedFile;

    // if (cachedFile != null) {
    //   cachedOrDownloadedFile = cachedFile.file;
    // } else {
    //   if (file.path.startsWith('http') || file.path.startsWith('https')) {
    //     // C'est une URL, donc utiliser CacheManager
    //     cachedOrDownloadedFile = await DefaultCacheManager().getSingleFile(file.path);
    //     controller = VideoPlayerController.file(cachedOrDownloadedFile);
    //   } else {
    //     // C'est un chemin de fichier local, pas besoin de passer par CacheManager
    //     controller = VideoPlayerController.file(File(file.path));
    //   }
    // }
    // //  controller = VideoPlayerController.file(File(file.path));
    //   //}
    // } else {}
  }

  Future<void> _playURL() async {
    print('uri = ${_instagramUrlController.text}');
    if (isCaptured ||
        (widget.controller != null &&
            _isValidInstagramUrl(widget.controller!.dataSource))) {
      if (_instagramUrlController.text.isNotEmpty) {
        String instagramUrl = _instagramUrlController.text;
        // Obtenez les métadonnées
        var data = await MetadataFetch.extract(instagramUrl);
        if (data != null && data.image != null && data.image!.isNotEmpty) {
          thumbnailUrl = data.image!; // Récupère l'image de prévisualisation
        } else {
          // setState(() {
          //   _thumbnailUrl = null;  // Aucun lien pour la vignette
          // });
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("Aucune vignette disponible pour ce lien")),
          // );
        }
      } else if (_isValidInstagramUrl(widget.controller!.dataSource)) {
        String instagramUrl = widget.controller!.dataSource;
        // Obtenez les métadonnées
        var data = await MetadataFetch.extract(instagramUrl);
        if (data != null && data.image != null && data.image!.isNotEmpty) {
          thumbnailUrl = data.image!; // Récupère l'image de prévisualisation
        }
      } else if (_isValidInstagramUrl(widget.controller!.dataSource)) {
        String instagramUrl = widget.controller!.dataSource;
        // Obtenez les métadonnées
        var data = await MetadataFetch.extract(instagramUrl);
        if (data != null && data.image != null && data.image!.isNotEmpty) {
          thumbnailUrl = data.image!; // Récupère l'image de prévisualisation
        }
      }
    } else {}
  }

  Future<void> _disposeVideoController() async {
    /*  if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;*/
    if (_controller != null) {
      await _controller!.dispose();
      setState(() {
        _controller = null;
        isCaptured = false;
      });
    }
    _controller = null;
  }

  Future<void> showDialogVideo() async {
    await showDialog(
        context: Get.context!,
        builder: (context) {
          return WillPopScope(
              onWillPop: () {
                _controller!.pause();
                return Future.value(true);
              },
              child: SafeArea(
                  child: Scaffold(
                body: Stack(alignment: Alignment.bottomCenter, children: [
                  Center(
                      child: FittedBox(
                          child: SizedBox(
                              height: _controller!.value.size.height > 0
                                  ? _controller!.value.size.height
                                  : 1,
                              width: _controller!.value.size.width > 0
                                  ? _controller!.value.size.width
                                  : 1,
                              child: VideoPlayer(_controller!)))),
                  _ControlsOverlay(controller: _controller!),
                  VideoProgressIndicator(
                    _controller!,
                    allowScrubbing: true,
                  ),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: InkWell(
                        onTap: () {
                          _controller!.pause();
                          Get.back();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(180)),
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            child: Icon(Icons.arrow_back,
                                size: width * 0.04,
                                color:
                                    Theme.of(context).colorScheme.onSurface))),
                  )
                ]),
              )) // _ControlsOverlay(controller: _controller!),
              );
        });
  }

  Future<void> popupChooseVideo() async {
    final ImagePicker picker = ImagePicker();
    await showDialog<PickedFile>(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
            insetPadding: EdgeInsets.only(left: 10, right: 10),
            child: Container(
                height: 300,
                padding: EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.choisissez_une_option,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  XFile? file = await _picker.pickVideo(
                                      source: ImageSource.gallery,
                                      maxDuration: null);
                                  setState(() {
                                    isCaptured = true;
                                    isLink = false;
                                    widget.file = File(file!.path);
                                  });
                                  _playVideo(file);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 12, right: 12, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .depuis_la_galerie,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                )),
                            InkWell(
                                onTap: () async {
                                  Navigator.of(context).pop();

                                  XFile? file = await _picker.pickVideo(
                                      source: ImageSource.camera,
                                      maxDuration: null);
                                  setState(() {
                                    isCaptured = true;
                                    isLink = false;
                                    widget.file = File(file!.path);
                                  });
                                  _playVideo(file);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 12, right: 12, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .prendre_une_video,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ))
                          ]),
                      Visibility(
                          visible: !widget.isRouteSetter,
                          child: Row(children: [
                            Expanded(
                                child: Divider(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                            SizedBox(width: 10),
                            Text(
                              AppLocalizations.of(context)!.ou,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Divider(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            )
                          ])),
                      Visibility(
                          visible: !widget.isRouteSetter,
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                controller: _instagramUrlController,
                                decoration: InputDecoration(
                                    labelText: 'Lien de la vidéo Instagram',
                                    hintText: '',
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: isValidUrl
                                            ? ColorsConstantDarkTheme
                                                .neutral_white
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: isValidUrl
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                        width: 2.0,
                                      ),
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer un lien Instagram';
                                  }
                                  // else if (!_isValidInstagramUrl(value)) {
                                  //   return 'Veuillez entrer un lien Instagram valide';
                                  // }
                                  return null;
                                },
                              )),
                              SizedBox(width: 10),
                              InkWell(
                                  onTap: () async {
                                    if (_isValidInstagramUrl(
                                        _instagramUrlController.text)) {
                                      //try if the url is valid

                                      setState(() {
                                        isCaptured = true;
                                        isLink = true;
                                        widget.url =
                                            _instagramUrlController.text;
                                      });
                                      _playURL();
                                    } else {
                                      isValidUrl = false;
                                    }
                                    Get.back();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 12, right: 12, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppLocalizations.of(context)!.valider,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  )),
                            ],
                          ))
                    ])));
      },
    );
  }

  bool _isValidInstagramUrl(String url) {
    // Vérifie que l'URL commence par https://www.instagram.com/
    final instagramRegex =
        RegExp(r"^(https?:\/\/)?(www\.)?instagram\.com\/reel/");
    return instagramRegex.hasMatch(url);
  }

  @override
  void dispose() {
    _controller != null ? _controller!.dispose() : null;
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => widget.wantKeepAlive;
}

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  final VideoPlayerController controller;

  @override
  State<_ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
  late VideoPlayerController _controller;
  late void Function() _listener;
  @override
  void initState() {
    _listener = () {
      setState(() {});
    };
    _controller = widget.controller..addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: _controller.value.isPlaying
              ? const SizedBox.shrink()
              : ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: ColorsConstantDarkTheme.neutral_white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          },
        ),
      ],
    );
  }
}
