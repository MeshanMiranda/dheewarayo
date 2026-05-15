import os
import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import copernicusmarine as cm
import xarray as xr
import numpy as np
import threading
import time
from datetime import datetime, timedelta
import gc

app = FastAPI(title="Copernicus Marine Optimized API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

_cache: dict = {
    "sst": None, 
    "ssh": None,  
    "chl": None, 
    "ready": False,
    "error": None,
    "loaded_at": None,
}

BBOX = dict(
    minimum_latitude=5.0,
    maximum_latitude=12.0,
    minimum_longitude=75.0,
    maximum_longitude=85.0,
)


def _date_range():
    end = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%S")
    start = (datetime.utcnow() - timedelta(days=3)).strftime("%Y-%m-%dT%H:%M:%S")
    return start, end


def load_datasets():
    global _cache
    try:
        start_date, end_date = _date_range()
        print(f"[Marine API] Loading datasets ({start_date} → {end_date}) ...")

        print("[Marine API] Fetching SST ...")
        if os.path.exists("temp_sst.nc"):
            os.remove("temp_sst.nc")
            
        cm.subset(
            dataset_id="cmems_mod_glo_phy-thetao_anfc_0.083deg_P1D-m",
            minimum_latitude=BBOX["minimum_latitude"],
            maximum_latitude=BBOX["maximum_latitude"],
            minimum_longitude=BBOX["minimum_longitude"],
            maximum_longitude=BBOX["maximum_longitude"],
            start_datetime=start_date,
            end_datetime=end_date,
            variables=["thetao"],
            output_filename="temp_sst.nc",
            overwrite_output_data=True,
        )
        ds_sst = xr.open_dataset("temp_sst.nc")

        da_sst = ds_sst["thetao"]
        if "depth" in da_sst.dims:
            da_sst = da_sst.isel(depth=0)
        if "time" in da_sst.dims:
            da_sst = da_sst.isel(time=-1)
        _cache["sst"] = (da_sst.latitude.values, da_sst.longitude.values, da_sst.values)
        ds_sst.close()
        del ds_sst, da_sst
        gc.collect()
        if os.path.exists("temp_sst.nc"):
            os.remove("temp_sst.nc")
        print("[Marine API] SST loaded.")


        print("[Marine API] Fetching SSH ...")
        if os.path.exists("temp_ssh.nc"):
            os.remove("temp_ssh.nc")
            
        cm.subset(
            dataset_id="cmems_mod_glo_phy_anfc_0.083deg_P1D-m",
            minimum_latitude=BBOX["minimum_latitude"],
            maximum_latitude=BBOX["maximum_latitude"],
            minimum_longitude=BBOX["minimum_longitude"],
            maximum_longitude=BBOX["maximum_longitude"],
            start_datetime=start_date,
            end_datetime=end_date,
            variables=["zos"],
            output_filename="temp_ssh.nc",
            overwrite_output_data=True,
        )
        ds_ssh = xr.open_dataset("temp_ssh.nc")
        da_ssh = ds_ssh["zos"]
        if "time" in da_ssh.dims:
            da_ssh = da_ssh.isel(time=-1)
        _cache["ssh"] = (da_ssh.latitude.values, da_ssh.longitude.values, da_ssh.values)
        ds_ssh.close()
        del ds_ssh, da_ssh
        gc.collect()
        if os.path.exists("temp_ssh.nc"):
            os.remove("temp_ssh.nc")
        print("[Marine API] SSH loaded.")

        print("[Marine API] Fetching Chlorophyll ...")
        if os.path.exists("temp_chl.nc"):
            os.remove("temp_chl.nc")
            
        cm.subset(
            dataset_id="cmems_mod_glo_bgc-pft_anfc_0.25deg_P1D-m_202311",
            minimum_latitude=BBOX["minimum_latitude"],
            maximum_latitude=BBOX["maximum_latitude"],
            minimum_longitude=BBOX["minimum_longitude"],
            maximum_longitude=BBOX["maximum_longitude"],
            start_datetime=start_date,
            end_datetime=end_date,
            variables=["chl"],
            output_filename="temp_chl.nc",
            overwrite_output_data=True,
        )
        ds_chl = xr.open_dataset("temp_chl.nc")
        da_chl = ds_chl["chl"]
        if "depth" in da_chl.dims:
            da_chl = da_chl.isel(depth=0)
        if "time" in da_chl.dims:
            da_chl = da_chl.isel(time=-1)
        _cache["chl"] = (da_chl.latitude.values, da_chl.longitude.values, da_chl.values)
        ds_chl.close()
        del ds_chl, da_chl
        gc.collect()
        if os.path.exists("temp_chl.nc"):
            os.remove("temp_chl.nc")
        print("[Marine API] Chlorophyll loaded.")

        _cache["ready"] = True
        _cache["loaded_at"] = datetime.utcnow().isoformat()
        _cache["error"] = None
        print("[Marine API] All datasets ready in memory.")

    except Exception as e:
        _cache["error"] = str(e)
        _cache["ready"] = False
        print(f"[Marine API] Dataset loading failed: {e}")


@app.on_event("startup")
def startup_event():
    thread = threading.Thread(target=load_datasets, daemon=True)
    thread.start()


@app.get("/api/status")
def get_status():
    return {
        "ready": _cache["ready"],
        "loaded_at": _cache["loaded_at"],
        "error": _cache["error"],
    }


def safe_nearest(cache_data, lat: float, lon: float, fallback: float) -> float:
    if cache_data is None:
        return fallback
    try:
        lats, lons, vals = cache_data
        lat_idx = np.abs(lats - lat).argmin()
        lon_idx = np.abs(lons - lon).argmin()
        val = vals[lat_idx, lon_idx]
        if np.isnan(val):
            return fallback
        return float(val)
    except Exception as e:
        print(f"[Marine API] sel error: {e}")
        return fallback


@app.get("/api/marine_data")
def get_marine_data(lat: float, lng: float):
    if not _cache["ready"]:
        return {
            "sst": 28.0,
            "chlorophyll": 0.5,
            "ssh": 0.0,
            "status": "loading",
        }

    sst = safe_nearest(_cache["sst"], lat, lng, fallback=28.0)
    ssh = safe_nearest(_cache["ssh"], lat, lng, fallback=0.0)
    chl = safe_nearest(_cache["chl"], lat, lng, fallback=0.5)

    return {
        "sst": float(np.clip(sst, 20.0, 35.0)),
        "chlorophyll": float(np.clip(chl, 0.0, 10.0)),
        "ssh": float(np.clip(ssh, -1.0, 1.0)),
        "status": "success",
    }


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(
        "marine_api:app",
        host="0.0.0.0",
        port=port,
        reload=False, 
    )