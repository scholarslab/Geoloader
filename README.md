# Geoloader

Geoloader is a simple little gem that automates the process of loading geospatial catalog holdings (for now, [GeoTIFFs][geotiff] and [Shapfiles][shapefile]) into the software stack used to power the spatial search interface at the University of Virginia Library - [PostGIS][postgis], [Geoserver][geoserver], and [Geonetwork][geonetwork].

## Usage

First, provide connection settings in a YAML file (see `test/config.yaml.changeme`):

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
  group:      "2"
  xslt:       "path/to/iso19139/xslt"
```

Then, use Geoloader programmatically in code:

```ruby
require 'geoloader'

# Point Geoloader at a configuration file.
Geoloader.config_from_yaml("/path/to/config.yaml")

# Load a GeoTIFF.
load_tiff = Geoloader::GeotiffLoader.new("/path/to/file.tif")
loader.load

# Load a Shapefile.
load_shp = Geoloader::ShapefileLoader.new("/path/to/file.shp")
loader.load
```

Or as a command-line utility, with global YAML settings in `~/.geoloader`:

```bash
geoloader load /var/spatial/nyc.tif
```

```bash
geoloader load /var/spatial/nyc.shp
```

[geotiff]: http://en.wikipedia.org/wiki/Geotiff
[shapefile]: http://en.wikipedia.org/wiki/Shapefile
[postgis]: http://postgis.net/
[geoserver]: http://geoserver.org/
[geonetwork]: http://geoserver.org/
