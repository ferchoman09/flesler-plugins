NAME=jquery.$(PLUGIN)
VER?=0.0.1

SRC=$(NAME).js
MIN=$(NAME)-min.js

VER_NAME=$(NAME)-$(VER)

SRCV=$(VER_NAME).js
MINV=$(VER_NAME)-min.js

ZIP=$(VER_NAME).zip
ZIP_FILES += $(SRC) $(MIN) changes.txt

all: deploy

$(ZIP): $(ZIP_FILES)
	zip -r9 $(ZIP) $(ZIP_FILES)

$(SRC):
	cp $(SRC) temp
	cat temp | $(add-version) | $(add-date) > $(SRC)
	rm temp
	
$(SRCV):$(SRC)
	cp $(SRC) $(SRCV)

$(MIN):$(SRC)
	java -jar $(YUI) $(SRC) -o $(MIN)

min: $(MIN)
	
$(MINV):$(MIN)
	cp $(MIN) $(MINV)
	
deploy:$(ZIP) $(SRCV) $(MINV)

# ---Replacements--- #

# Version
define add-version
sed -e 's/^\(.*@version \)[0-9.]\+\(.*\)$|/\1$(VER)\2/'
endef

# Date
TODAY=${shell date +%m\\/%d\\/%Y}
define add-date
sed -e 's/^\(.*Date: \)[0-9/]\+\(.*\)$|/\1$(TODAY)\2/'
endef

# ---Cleaning--- #

# Can be extended
define cmdclean
rm -f $(MIN) $(SRCV) $(MINV) $(ZIP);
endef

clean:
	$(cmdclean)

.PHONY: clean deploy min $(SRC)
