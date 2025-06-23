using com.kartun.movie_studio as M from '../db/schema';
using { Currency, cuid } from '@sap/cds/common';

service AssetsService {

  @odata.draft.enabled: true
  entity Assets as projection on M.Asset {
    ID,
    name,
    type,
    status,
    location,
    movie
  }

  function getAvailableAssets(
    type : String
  ) returns many Assets
    @odata.contained: false;

  @readonly entity AssetStatus as projection on M.AssetStatus;
  @readonly entity AssetType as projection on M.AssetType;
  @readonly entity Location as projection on M.Location;

  
}