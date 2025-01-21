const emailRegex = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
final RegExp numberRegex = RegExp(r'([0-9]+)');

final RegExp subdomainRegExp = RegExp(
  r"[A-Za-z0-9](?:[A-Za-z0-9\-]{0,61}[A-Za-z0-9])?",
);

final RegExp pointsToRegExp = RegExp(
  r"^([a-zA-Z0-9-]+\.)*[a-zA-Z0-9-]+\.[a-zA-Z]{2,24}(\.[a-zA-Z]{2,24})?$",
);

final RegExp ipAddressRegExp = RegExp(
  r"^(?:2[0-4][0-9]|25[0-5]|1?[0-9]?[0-9])\.(?:2[0-4][0-9]|25[0-5]|1?[0-9]?[0-9])\.(?:2[0-4][0-9]|25[0-5]|1?[0-9]?[0-9])\.(?:2[0-4][0-9]|25[0-5]|1?[0-9]?[0-9])$",
);
