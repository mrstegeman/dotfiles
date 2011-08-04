from ranger.defaults.apps import CustomApplications as DefaultApps
from ranger.api.apps import *
		
class CustomApplications(DefaultApps):
	def app_default(self, c):
		f = c.file #shortcut

		if f.extension is not None:
			if f.extension in ('html', 'htm', 'xhtml'):
				return self.either(c, 'firefox', 'chromium', 'opera', 'jumanji',
						'luakit', 'elinks', 'lynx')
			if f.extension == 'apk':
				return self.either(c, 'xarchiver', 'aunpack', 'file_roller')

		if f.container:
			return self.either(c, 'xarchiver', 'aunpack', 'file_roller')

		return DefaultApps.app_default(self, c)

# Often a programs invocation is trivial.  For example:
#    vim test.py readme.txt [...]
# This could be implemented like:
#    @depends_on("vim")
#    def app_vim(self, c):
#        return tup("vim", *c.files)
# Instead of creating such a generic function for each program, just add
# its name here and it will be automatically done for you.
CustomApplications.generic('vim', 'fceux', 'elinks', 'wine',
		'zsnes', 'javac', 'xarchiver', 'chromium')

# By setting flags='d', this programs will not block ranger's terminal:
CustomApplications.generic('opera', 'firefox', 'apvlv', 'evince',
		'zathura', 'gimp', 'mirage', 'eog', flags='d')

# What filetypes are recognized as scripts for interpreted languages?
# This regular expression is used in app_default()
INTERPRETED_LANGUAGES = re.compile(r'''
	^(text|application)/x-(
		haskell|perl|python|ruby|sh|lua
	)$''', re.VERBOSE)
