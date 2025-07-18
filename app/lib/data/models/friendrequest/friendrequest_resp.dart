enum FriendStatus { FRIEND, PENDING, NOT_FRIEND, REQUESTED }

FriendStatus friendStatusFromJson(String? status) {
  switch (status) {
    case 'FRIEND':
      return FriendStatus.FRIEND;
    case 'PENDING':
      return FriendStatus.PENDING;
    case 'REQUESTED':
      return FriendStatus.REQUESTED;
    default:
      return FriendStatus.NOT_FRIEND;
  }
}
