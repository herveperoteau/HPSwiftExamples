#  Firebase

<!--
LIst de tous les spots créés par userUUID
-->

## /owner/_userUUID_/spots/

owner
	spots
		workers
		
worker
	spots
	
		
		
```js

[
	{
		spotUUID: "xxxx",
		spotName: "xxxx"
		
	}
]

grunt.initConfig({
assemble: {
options: {
assets: 'docs/assets',
data: 'src/data/*.{json,yml}',
helpers: 'src/custom-helpers.js',
partials: ['src/partials/**/*.{hbs,md}']
},
pages: {
options: {
layout: 'default.hbs'
},
files: {
'./': ['src/templates/pages/index.hbs']
}
}
}
};




