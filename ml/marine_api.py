import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import copernicusmarine as cm
import xarray as xr
import pandas as pd
from datetime import datetime

app = FastAPI(title="Copernicus Marine Local API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global variables to hold datasets for fast access
ds_sst = None
ds_ssh = None
ds_chl = None

@app.on_event("startup")
async def startup_event():
    global ds_sst, ds_ssh, ds_chl
    print("Loading Copernicus Marine datasets. This might take a few seconds...")
    try:
        # Load SST (thetao)
        ds_sst = cm.open_dataset(dataset_id="cmems_mod_glo_phy-thetao_anfc_0.083deg_P1D-m")
        # Load SSH (zos)
        ds_ssh = cm.open_dataset(dataset_id="cmems_mod_glo_phy_anfc_0.083deg_P1D-m")
        # Load Chlorophyll (chl)
        ds_chl = cm.open_dataset(dataset_id="cmems_mod_glo_bgc-pft_anfc_0.25deg_P1D-m_202311")
        print("Datasets loaded successfully!")
    except Exception as e:
        print(f"Error loading datasets: {e}")

@app.get("/api/marine_data")
async def get_marine_data(lat: float, lng: float):
    global ds_sst, ds_ssh, ds_chl
    
    if ds_sst is None or ds_ssh is None or ds_chl is None:
        raise HTTPException(status_code=503, detail="Datasets are not initialized yet")

    try:
        # Select the nearest coordinate, and the latest time available
        # Some variables are 3D (with depth), so we select depth=0.494 (surface) or nearest to 0
        
        # 1. SST (thetao)
        # Using .isel(time=-1) gets the latest available time step
        val_sst = ds_sst['thetao'].sel(latitude=lat, longitude=lng, method='nearest')
        if 'depth' in val_sst.dims:
            val_sst = val_sst.sel(depth=0, method='nearest')
        if 'time' in val_sst.dims:
            val_sst = val_sst.isel(time=-1)
        sst_res = float(val_sst.values)

        # 2. SSH (zos)
        val_ssh = ds_ssh['zos'].sel(latitude=lat, longitude=lng, method='nearest')
        if 'time' in val_ssh.dims:
            val_ssh = val_ssh.isel(time=-1)
        ssh_res = float(val_ssh.values)

        # 3. Chlorophyll (chl)
        val_chl = ds_chl['chl'].sel(latitude=lat, longitude=lng, method='nearest')
        if 'depth' in val_chl.dims:
            val_chl = val_chl.sel(depth=0, method='nearest')
        if 'time' in val_chl.dims:
            val_chl = val_chl.isel(time=-1)
        chl_res = float(val_chl.values)

        return {
            "sst": max(20.0, min(35.0, sst_res)) if not pd.isna(sst_res) else 28.0,
            "chlorophyll": max(0.0, min(10.0, chl_res)) if not pd.isna(chl_res) else 0.5,
            "ssh": max(-1.0, min(1.0, ssh_res)) if not pd.isna(ssh_res) else 0.0,
        }
        
    except Exception as e:
        print(f"Error extracting data: {e}")
        # Return fallback values on error so the app doesn't crash
        return {
            "sst": 28.0,
            "chlorophyll": 0.5,
            "ssh": 0.0,
        }

if __name__ == "__main__":
    uvicorn.run("marine_api:app", host="0.0.0.0", port=8000, reload=True)
