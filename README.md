# Geoloader

[![Code Climate](https://codeclimate.com/github/scholarslab/Geoloader.png)](https://codeclimate.com/github/scholarslab/Geoloader)

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

# Merge markdown metadata into the Solr documents:
geoloader solr load /path/to/files/* --description /path/to/markdown

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

# Merge markdown metadata into the ISO19139 records:
geoloader geonetwork load /path/to/files/* --description /path/to/markdown

# Push the jobs onto a Resque queue:
geoloader geonetwork load /path/to/files/* --queue

# Clear all documents in a workspace:
geoloader geonetwork clear workspace
```

#### Or, from ruby

```ruby
# Load a Geotiff to Geoserver:
Geoloader::GeotiffGeoserverLoader.new("/path/to/file", "workspace", "/path/to/desc.md"}).load

# Load a Geotiff to Solr:
Geoloader::GeotiffSolrLoader.new("/path/to/file", "workspace", "/path/to/desc.md"}).load

# Load a Shapefile to Geoserver:
Geoloader::ShapefileGeotiffLoader.new("/path/to/file", "workspace", "/path/to/desc.md"}).load

# Load a Shapefile to Solr:
Geoloader::ShapefileSolrLoader.new("/path/to/file", "workspace", "/path/to/desc.md").load

# Load a Geotiff or Shapefile to Geonetwork:
Geoloader::GeonetworkLoader.new("/path/to/file", "workspace", "/path/to/desc.md").load

# Or use any of the loader classes as a Resque job:
Resque.enqueue(Geoloader::GeotiffSolrLoader, "/path/to/file", "workspace", "/path/to/desc.md")
```

## Installation and Configuration

To get started, clone the repo and install the gem:

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
  srs:        EPSG:3857

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

Which are automatically applied to the configuration when the gem is loaded.

#### Descriptive Metadata

Geoloader also makes it possible to provide text metadata about assets in Markdown files, which are parsed and merged into the records that are pushed out to the services. These files have three parts:

  1. A YAML "front matter" section, delimited by `---` dividers. This makes it possible to provide arbitrary key-value metadata, which can be merged into records created by the concrete asset modules.

  2. A leading `<h1>` element, represented in Markdown as a line that starts with a single `#` - eg, `# Testing Title`. This value is used as the generic title for the asset(s).

  3. The rest of the Markdown document, which is used as an "abstract" or "description."

For example, here's what a description file for an upload to Geonetwork might look like:

```markdown
---
categories:
  - category1
  - category2

keywords:
  - keyword1
  - keyword2
---

# Testing Title

A testing abstract! More content here.
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
