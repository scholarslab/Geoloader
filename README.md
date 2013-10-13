# Geoloader

Geoloader is a simple little gem that automates the process of loading geospatial catalog holdings (for now, [GeoTIFFs][geotiff] and [Shapfiles][shapefile]) into the software stack used to power the spatial search interface at the University of Virginia Library - [PostGIS][postgis], [Geoserver][geoserver], and [Geonetwork][geonetwork].

## Usage

First, provide connection settings in a YAML file:

```yaml
postgis:
  host:       "localhost"
  port:       "5432"
  username:   "admin"
  password:   "admin"
  prefix:     "geoloader"

geoserver:
  url:        "http://localhost:8080/geoserver/rest"
  username:   "admin"
  password:   "geoserver"
  workspace:  "geoloader"
  srs:        "EPSG:900913"

geonetwork:
  url:        "http://localhost:8080/geonetwork/srv/en"
  username:   "admin"
  password:   "admin"
  xslt:       "path/to/iso19139/xslt"
  group:      "geoloader"
```

Then, use Geoloader programmatically in code:

```ruby
require 'geoloader'

# Point Geoloader at a configuration file.
Geoloader.configure("/path/to/config.yaml")

# Load a GeoTIFF.
tiff_loader = Geoloader::GeotiffLoader.new("/path/to/file.tif")
tiff_loader.load

# Unload a GeoTIFF.
tiff_loader.unload

# Load a Shapefile.
shp_loader = Geoloader::ShapefileLoader.new("/path/to/file.shp")
shp_loader.load

# Unload a Shapefile.
shp_loader.unload
```

Or as a command-line utility, with global YAML settings in `~/.geoloader/config.yaml`:

```bash
geoloader load /var/spatial/nyc.tif
geoloader unload /var/spatial/nyc.tif
```

```bash
geoloader load /var/spatial/nyc.shp
geoloader unload /var/spatial/nyc.shp
```

[geotiff]: http://en.wikipedia.org/wiki/Geotiff
[shapefile]: http://en.wikipedia.org/wiki/Shapefile
[postgis]: http://postgis.net/
[geoserver]: http://geoserver.org/
[geonetwork]: http://geoserver.org/
