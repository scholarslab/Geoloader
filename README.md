## Geoloader

Geoloader is a simple little gem that automates the process of loading geospatial catalog holdings (for now, GeoTIFFs and Shapfiles) into the software stack used to power the spatial search interface at the University of Virginia Library - [PostGIS][postgis], [Geoserver][geoserver], and [Geonetwork][geonetwork].

## Usage

First, provide connection parameters in a YAML configuration file:

```yaml
postgis:
  host:       "localhost"
  port:       "5432"
  username:   "admin"
  password:   "admin"

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
```

And Geoloader programmatically in code:

```ruby
require 'geoloader'

# Set a custom configuration file.
Geoloader.config_from_yaml("/path/to/config.yaml")

# Load a GeoTIFF.
load_tiff = Geoloader::GeotiffLoader.new("/path/to/file.tif")
loader.work

# Load a Shapefile.
load_shp = Geoloader::ShapefileLoader.new("/path/to/file.shp")
loader.work
```

Or as a command line utility, with global settings in `~/.geoloader`:

`geoloader load /var/spatial/nyc.tif`
`geoloader load /var/spatial/nyc.shp`


[postgis]: http://postgis.net/
[geoserver]: http://geoserver.org/
[geonetwork]: http://geoserver.org/
