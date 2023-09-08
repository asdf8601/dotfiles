#for filename in logos_transparent/*;
#do
#	basename="$(basename $filename)"
#	magick convert logos_transparent/${basename} -resize 360x240 -background transparent -compose Copy \
#   -gravity center -extent 360x240  logos_resized/${basename}
#done#
#
#

##identify -format "%f %wx%h\n" *#
#
#

#magick convert usa_tiger.png -resize 360x240 -background transparent -compose Copy \
#   -gravity center -extent 360x240  usa_tiger_large.png#
#

#magick convert apple_large.png -resize 75% -background transparent -compose Copy \
#   -gravity center -extent 360x240  test.png


imgfix() {
	# EXAMPLE: imgfix picture.png output.png 40% 360x240
	convert $1 \
		-resize $3 \
		-compose Copy \
		-gravity center \
		-extent $4 $2

		# -fuzz 0% -transparent white \
		# -transparent white \
		# -background transparent \
}


pixels() {
	find -E . -regex ".*(.png|.jpeg|.jpg)" -exec identify -format "%f %wx%h\n" {} ";"
}


imgfix $1 $2 $3 $4
