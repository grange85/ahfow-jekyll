---
layout: null
---
{% assign releases = site.damon-and-naomi-releases %}
MATCH (dan:Band {name: "Damon & Naomi"}) WITH dan

{% for release in releases %}{% if release.artist != "Magic Hour" and release.section != "04-dvd" %}
{% for version in release.releases %}{% if version.graph %}{% for group in version.groups %}{% for track in group.tracks %}{% unless track.title contains "^" %}
MERGE (t{{track.title | slugify | replace: "-", ""}}:Track {%raw%}{{%endraw%}name: "{{track.title}}"{%raw%}}{%endraw%}) {% endunless %}{% endfor %}{% endfor %}{% endif %}{% endfor %}{% endif %}{% endfor %}



{% for release in releases %}{% if release.artist != "Magic Hour" and release.section != "04-dvd" %}
{% for version in release.releases %}{% if version.graph %}
MERGE (r{{release.albumname | slugify | replace: "-",""}}:Release {%raw%}{{%endraw%}name:"{{release.albumname}}{%raw%}"}{%endraw%})
MERGE (dan)-[:RELEASED]->(r{{release.albumname | slugify | replace: "-",""}})
MERGE (r{{release.albumname | slugify | replace: "-", ""}}v{{version.version | slugify | replace: "-", ""}}:Version {%raw%}{{%endraw%}name:"{{version.label}} ({{version.format | slugify | replace: "-", ""}}, {{version.year}}){%raw%}"}{%endraw%})
MERGE (r{{release.albumname | slugify | replace: "-", ""}}v{{version.version | slugify | replace: "-", ""}})-[:RELEASE_OF]->(r{{release.albumname | slugify | replace: "-",""}})

{% for group in version.groups %}{% for track in group.tracks %}
MERGE (t{{track.title | slugify | replace: "-", ""}})-[r{{track.title | slugify | replace: "-", ""}}{{track.notes | slugify | replace: "-", ""}}{{version.version | slugify | replace: "-", ""}}:INCLUDED_ON]->(r{{release.albumname | slugify | replace: "-", ""}}v{{version.version | slugify | replace: "-", "" }})
SET r{{track.title | slugify | replace: "-", ""}}{{track.notes | slugify | replace: "-", ""}}{{version.version | slugify | replace: "-", ""}}.position = {{forloop.index}}
{% endfor %}{% endfor %}{%endif%}{% endfor %}{%endif%}{% endfor %}
