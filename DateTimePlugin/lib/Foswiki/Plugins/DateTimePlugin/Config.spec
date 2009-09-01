# ---+ Extensions
# ---++ DateTimePlugin
# **PERL**
# Localized date names: Portuguese
$Foswiki::cfg{Plugins}{DateTimePlugin}{Dates}{pt} = {
	months_long => 'Janeiro, Fevereiro, Mar&ccedil;o, Abril, Maio, Junho, Julho, Agosto, Setembro, Outubro, Novembro, Dezembro',
	months_short => 'Jan, Fev, Mar, Abr, Mai, Jun, Jul, Ago, Set, Out, Nov, Dez',
	weekdays_long => 'Domingo, Segunda-feira, Ter&ccedil;a-feira, Quarta-feira, Quinta-feira, Sexta-feira, S&aacute;bado',
	weekdays_short => 'Dom, Seg, Ter, Qua, Qui, Sex, Sab',
};
# **PERL**
# Localized date names: Dutch
$Foswiki::cfg{Plugins}{DateTimePlugin}{Dates}{nl} = {
	months_long => 'Januari, Februari, Maart, April, Mei, Juni, Juli, Augustus, September, Oktober, November, December',
	months_short => 'Jan, Feb, Maa, Apr, Mei, Jun, Jul, Aug, Sep, Okt, Nov, Dec',
	weekdays_long => 'Zondag, Maandag, Dinsdag, Woensdag, Donderdag, Vrijdag, Zaterdag',
	weekdays_short => 'Zon, Maa, Din, Woe, Don, Vri, Zat',
};
# **STRING 3**
# Timezone offset in hours (may be a negative number).
$Foswiki::cfg{Plugins}{DateTimePlugin}{TimezoneOffset} = '0';
# **BOOLEAN**
# Enable debugging (debug messages will be written to data/debug.txt)
$Foswiki::cfg{Plugins}{DateTimePlugin}{Debug} = 0;
