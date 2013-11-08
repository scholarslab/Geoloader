# Geoloader

Geoloader is a simple little gem that automates the process of loading [GeoTIFFs][geotiff] and [Shapfiles][shapefile] into [Geoserver][geoserver], and [Solr][solr], the services that power the geospatial search interface at the University of Virginia Library.

## Quick Examples

From the command line:

```bash
# Load an individual GeoTIFF to Geoserver and Solr:
geoloader load /path/to/geotiff.tif

# Load an individual Shapefile to Geoserver and Solr:
geoloader load /path/to/shapefile.shp

# Load all files matched by wildcard to Geoserver and Solr:
geoloader load /path/to/files/*

# Load files just to Geoserver:
geoloader load /path/to/files/* --services geoserver

# Load files just to Solr:
geoloader load /path/to/files/* --services solr

# Load files to a custom workspace:
geoloader load /path/to/files/* --workspace aerials

# Merge YAML-defined metadata into the Solr documents:
geoloader load /path/to/files/* --metadata /path/to/yaml

# Push the upload jobs onto a Resque queue:
geoloader load /path/to/files/* --queue

# Start a Resque worker on the Geoloader queue:
geoloader work

# List all existing workspaces with asset counts:
geoloader list

# Clear all assets in a workspace:
geoloader clear aerials
```

Ruby:

```ruby
# Load a Geotiff to Geoserver:
Geoloader::GeotiffGeoserverLoader.new("/path/to/file", "workspace", {:solr => "metadata"}).load

# Load a Geotiff to Solr:
Geoloader::GeotiffSolrLoader.new("/path/to/file", "workspace", {:solr => "metadata"}).load

# Load a Shapefile to Geoserver:
Geoloader::ShapefileGeotiffLoader.new("/path/to/file", "workspace", {:solr => "metadata"}).load

# Load a Shapefile to Solr:
Geoloader::ShapefileSolrLoader.new("/path/to/file", "workspace", {:solr => "metadata"}).load

# Or use any of the loader classes as a Resque job:
Resque.enqueue(Geoloader::GeotiffSolrLoader, "/path/to/file", "workspace", {:solr => "metadata"})
```

## Installation and Configuration

To get started, clone the repo and install the gem with the [Jeweler][jeweler] task:

```
rake install
```

Then, you'll need to point Geoloader at running instances of Geoserver and Solr. By default, Geoloader starts by applying the configuration settings in the top-level `config.yaml` file:

```yaml
workspaces:
  default:    geoloader
  testing:    geoloader_test

geoserver:
  url:        http://localhost:8080/geoserver
  username:   admin
  password:   geoserver
  srs:        EPSG:900913

solr:
  url:        http://localhost:8080/solr/geoloader
```

Depending on your needs, you can override some or all of these settings. For example, you'll almost always need to set custom credentials for Geoserver.

#### Ruby

If you're using Geoloader programmatically in code, pass any hash-like object to the `configure` method on the `Geoloader` module to set configuration options directly:

```ruby
require "geoloader"

Geoloader.configure({
  :geoserver => {
    :username => "gs_username",
    :username => "gs_password"
  }
})
```

Or, put your custom settings in a separate YAML file:

```yaml
geoserver:
  username: gs_username
  password: gs_password
```

And apply them in bulk with `configure_from_yaml`:

```ruby
require "geoloader"

Geoloader.configure_from_yaml("/path/to/geoloader.yaml")
```

#### CLI Application

If you're using Geoloader as a command-line tool, provide custom connection parameters in `~/.geoloader.yaml`, and the values will automatically be merged into the default configuration at runtime:

```yaml
# ~/.geoloader.yaml

geoserver:
  username: gs_username
  password: gs_password
```

[geotiff]: http://en.wikipedia.org/wiki/Geotiff
[shapefile]: http://en.wikipedia.org/wiki/Shapefile
[geoserver]: http://geoserver.org/
[solr]: http://lucene.apache.org/solr/
[jeweler]: https://github.com/technicalpickles/jeweler
