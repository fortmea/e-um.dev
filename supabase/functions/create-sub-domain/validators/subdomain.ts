import { SupabaseClient } from "jsr:@supabase/supabase-js@2";
import { Filter } from "npm:bad-words";
const subdomainRegExp = new RegExp(
  "[A-Za-z0-9](?:[A-Za-z0-9\-]{0,61}[A-Za-z0-9])?",
);
const pointsToRegExp = new RegExp(
  "([a-z0-9A-Z]\.)*[a-z0-9-]+\.([a-z0-9]{2,24})+(\.co\.([a-z0-9]{2,24})|\.([a-z0-9]{2,24}))*",
);

const ipAddressRegExp = new RegExp(
  "^(?:2[0-4][0-9]|25[0-5]|1?[0-9]?[0-9])\\.(?:2[0-4][0-9]|25[0-5]|1?[0-9]?[0-9])\\.(?:2[0-4][0-9]|25[0-5]|1?[0-9]?[0-9])\\.(?:2[0-4][0-9]|25[0-5]|1?[0-9]?[0-9])$",
  "gm",
);

export async function validateSubDomain(
  name: string,
  pointsTo: string,
  supabaseClient: SupabaseClient,
  type: number,
): Promise<boolean> {
  const profanityFilter = new Filter();
  const { data, error } = await supabaseClient.from(
    "records",
  ).select(
    "*",
  ).eq(
    "name",
    name,
  ).limit(1);
  let pointsToValid = false;
  if (type == 1) {
    pointsToValid = pointsTo.match(pointsToRegExp)?.[0] == pointsTo;
  } else {
    pointsToValid = pointsTo.match(ipAddressRegExp)?.[0] == pointsTo;
  }
  console.log(pointsToValid);
  console.log(pointsTo);
  console.log(pointsTo.match(ipAddressRegExp));
  console.log(pointsTo.match(pointsToRegExp));

  return (!profanityFilter.isProfane(name) && data?.length == 0) && !error &&
    name.match(subdomainRegExp)?.[0] == name && pointsToValid == true;
}
