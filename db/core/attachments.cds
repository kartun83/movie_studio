namespace com.kartun.movie_studio;

using { cuid, managed } from '@sap/cds/common';

entity FileAttachment : cuid, managed {
  entity    : String(100);
  entity_ID : UUID;
  fileName  : String(255);
  mimeType  : String(100);
  url       : String(500);
}
