# Geoloader

Geoloader automates the process of loading [GeoTIFFs][geotiff] and [Shapfiles][shapefile] into [Geoserver][geoserver], [Geonetwork][geonetwork], and [Solr][solr], the services that power the geospatial search interface at the University of Virginia Library.

## Quick Examples

#### `geoloader solr`

Load files to Solr.

```bash
# Load files matched by wildcard:
geoloader solr load /path/to/files/*

# Load an individual Geotiff:
geoloader solr load /path/to/geotiff.tif

# Load an individual Shapefile:
geoloader solr load /path/to/shapefile.sh

# Load files to a custom workspace:
geoloader solr load /path/to/files/* --workspace aerials

# Merge YAML-defined metadata into the Solr documents:
geoloader solr load /path/to/files/* --metadata /path/to/yaml

# Push the jobs onto a Resque queue:
geoloader solr load /path/to/files/* --queue

# Clear all documents in a workspace:
geoloader solr clear workspace
```

#### `geoloader geoserver`

Load files to Geoserver.

```bash
# Load files matched by wildcard:
geoloader geoserver load /path/to/files/*

# Load an individual Geotiff:
geoloader geoserver load /path/to/geotiff.tif

# Load an individual Shapefile:
geoloader geoserver load /path/to/shapefile.sh

# Load files to a custom workspace:
geoloader geoserver load /path/to/files/* --workspace aerials

# Push the jobs onto a Resque queue:
geoloader geoserver load /path/to/files/* --queue

# Clear all documents in a workspace:
geoloader geoserver clear workspace
```

#### `geoloader geonetwork`

Load files to Geonetwork.

```bash
# Load files matched by wildcard:
geoloader geonetwork load /path/to/files/*

# Load an individual Geotiff:
geoloader geonetwork load /path/to/geotiff.tif

# Load an individual Shapefile:
geoloader geonetwork load /path/to/shapefile.sh

# Load files to a custom workspace:
geoloader geonetwork load /path/to/files/* --workspace aerials

# Push the jobs onto a Resque queue:
geoloader geonetwork load /path/to/files/* --queue

# Clear all documents in a workspace:
geoloader geonetwork clear workspace
```

#### Or, from ruby

```ruby
# Load a Geotiff to Geoserver:
Geoloader::GeotiffGeoserverLoader.new("/path/to/file", "workspace", {:solr => "metadata"}).load

# Load a Geotiff to Solr:
Geoloader::GeotiffSolrLoader.new("/path/to/file", "workspace", {:solr => "metadata"}).load

# Load a Shapefile to Geoserver:
Geoloader::ShapefileGeotiffLoader.new("/path/to/file", "workspace", {:solr => "metadata"}).load

# Load a Shapefile to Solr:
Geoloader::ShapefileSolrLoader.new("/path/to/file", "workspace", {:solr => "metadata"}).load

# Load a Geotiff or Shapefile to Geonetwork:
Geoloader::GeonetworkLoader.new("/path/to/file", "workspace", {:solr => "metadata"}).load

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
  production: geoloader
  testing:    geoloader_test

solr:
  url:        http://localhost:8080/solr/geoloader

geoserver:
  url:        http://localhost:8080/geoserver
  username:   admin
  password:   geoserver
  srs:        EPSG:900913

geonetwork:
  url:        http://localhost:8080/geonetwork/srv/en
  username:   admin
  password:   admin
  group:      geoloader
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

Or, put any combination of custom settings in a separate YAML file:

```yaml
geoserver:
  username: gs_username
  password: gs_password
```

And apply them with `configure_from_yaml`:

```ruby
require "geoloader"

Geoloader.configure_from_yaml("/path/to/geoloader.yaml")
```

#### CLI Application

If you're using Geoloader as a command-line tool, provide custom settings in `~/.geoloader.yaml`, and the values will automatically be merged into the default configuration at runtime:

```yaml
# ~/.geoloader.yaml

geoserver:
  username: gs_username
  password: gs_password
```

[geotiff]: http://en.wikipedia.org/wiki/Geotiff
[shapefile]: http://en.wikipedia.org/wiki/Shapefile
[geoserver]: http://geoserver.org/
[geonetwork]: http://geonetwork-opensource.org/
[solr]: http://lucene.apache.org/solr/
[jeweler]: https://github.com/technicalpickles/jeweler
