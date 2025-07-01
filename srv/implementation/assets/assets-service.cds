using com.kartun.movie_studio as M from '../../../db/schema';
using { Currency, cuid } from '@sap/cds/common';
// using from './assets-service';

service AssetsService {

  entity Assets @(restrict: [
    { grant: ['WRITE'], to: ['Admin', 'AssetManager', 'StudioDirector'] },
    { grant: '*', where: 'created_by = $user' },
    { grant: 'READ', to: 'authenticated-user' } 
//    { grant: 'READ', where: 'created_by = $user' }
  ])
    as projection on M.Asset {
    ID,
    name,
    type @assert.integrity,
    status @assert.integrity,
    location @assert.integrity,
    movie,
  }

  function getAvailableAssets @(requires: 'authenticated-user')(
    type : String
  ) returns many Assets;

  @readonly entity AssetStatus as projection on M.AssetStatus;
  @readonly entity AssetType as projection on M.AssetType;
  @readonly entity Location as projection on M.Location;

  function sleep() returns Boolean;
}

annotate AssetsService.Assets with @(//odata.draft.enabled, 
      fiori.draft.enabled,
      requires: ['AssetManager']);
//annotate AssetsService.Assets with @fiori.draft.enabled;
