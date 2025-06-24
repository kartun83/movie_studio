using com.kartun.movie_studio as M from '../../../db/schema';
using { Currency, cuid } from '@sap/cds/common';
// using from './assets-service';

service AssetsService {

  entity Assets as projection on M.Asset {
    ID,
    name,
    type @assert.integrity,
    status @assert.integrity,
    location @assert.integrity,
    movie,
  }

  function getAvailableAssets(
    type : String
  ) returns many Assets;

  @readonly entity AssetStatus as projection on M.AssetStatus;
  @readonly entity AssetType as projection on M.AssetType;
  @readonly entity Location as projection on M.Location;

  
}

annotate AssetsService.Assets with @odata.draft.enabled;
annotate AssetsService.Assets with @fiori.draft.enabled;
