client/script = {"<style>
body					{font-family: Verdana, sans-serif;}

h1, h2, h3, h4, h5, h6	{color: #0000ff;font-family: Georgia, Verdana, sans-serif;}

em						{font-style: normal;font-weight: bold;}

.motd					{color: #638500;font-family: Verdana, sans-serif;}
.motd h1, .motd h2, .motd h3, .motd h4, .motd h5, .motd h6
						{color: #638500;text-decoration: underline;}
.motd a, .motd a:link, .motd a:visited, .motd a:active, .motd a:hover
						{color: #638500;}

.prefix					{font-weight: bold;}
.log_message			{color: #386aff;	font-weight: bold;}

/* OOC */
.ooc					{font-weight: bold;}
.ooc img.text_tag		{width: 32px; height: 10px;}

.ooc .everyone			{color: #002eb8;}
.ooc .looc				{color: #3a9696;}
.ooc .elevated			{color: #306082;}
.ooc .moderator			{color: #184880;}
.ooc .developer			{color: #1b521f;}
.ooc .admin				{color: #b82e00;}
.ooc .aooc				{color: #960018;}

.staffwarn				{color: #ff0000; font-weight:bold; font-size: 150%;}
/* Admin: Private Messages */
.pm  .howto				{color: #ff0000;	font-weight: bold;		font-size: 200%;}
.pm  .in				{color: #ff0000;}
.pm  .out				{color: #ff0000;}
.pm  .other				{color: #0000ff;}

/* Admin: Channels */
.mod_channel			{color: #735638;	font-weight: bold;}
.mod_channel .admin		{color: #b82e00;	font-weight: bold;}
.admin_channel			{color: #ff5097;	font-weight: bold;}

.staff_channel			{color: #a66300;	font-weight: bold;}
.staff_channel .admin	{color: #b82e00;	font-weight: bold;}
.staff_channel .developer {color: #1b521f;	font-weight: bold;}

/* Radio: Misc */
.deadsay				{color: #530fad;}
.radio					{color: #408010;}
.deptradio				{color: #ff00ff;}	/* when all other department colors fail */
.newscaster				{color: #750000;}

/* Radio Channels */
.comradio				{color: #204090;}
.syndradio				{color: #6d3f40;}
.centradio				{color: #5c5c7c;}
.airadio				{color: #ff00ff;}
.entradio				{color: #666666;}

.secradio				{color: #930000;}
.engradio				{color: #a66300;}
.medradio				{color: #009190;}
.sciradio				{color: #993399;}
.supradio				{color: #7f6539;}
.srvradio				{color: #709b00;}
.expradio				{color: #929820;}
.seciradio				{color: #935050;}
.mediradio				{color: #509190;}

/* Miscellaneous */
.name					{font-weight: bold;}
.say					{}
.alert					{color: #ff0000;}
h1.alert, h2.alert		{color: #000000;}

.emote					{font-style: italic;}

/* Game Messages */

.attack					{color: #ff0000;}
.moderate				{color: #cc0000;}
.disarm					{color: #990000;}
.passive				{color: #660000;}

.italic				{font-style: italic;}
.bold					{font-weight: bold;}
.danger					{color: #ff0000; font-weight: bold;}
.bigdanger					{color: #ff0000; font-weight: bold; font-size: 115%;}
.warning				{color: #ff0000; font-style: italic;}
.bigwarning				{color: #ff0000; font-style: italic; font-size: 115%;}
.boldannounce			{color: #ff0000; font-weight: bold;}
.rose					{color: #ff5050;}
.info					{color: #0000cc;}
.notice					{color: #000099;}
.subtle					{color: #000099; font-size: 75%; font-style: italic;}
.alium					{color: #00ff00;}
.cult					{color: #800080; font-weight: bold; font-style: italic;}
.cultannounce			{color: #800080; font-style: italic; font-size: 175%;}
.mfauna					{color: #884422; font-weight: bold; font-size: 125%;}
.antagdesc				{color: #ff0033}

.reflex_shoot			{color: #000099; font-style: italic;}

/* Languages */

.alien					{color: #543354;}
.tajaran				{color: #803b56;}
.tajaran_signlang		{color: #941c1c;}
.skrell					{color: #00ced1;}
.soghun					{color: #228b22;}
.yeosa					{color: #218b89;}
.nabber_lang			{color: #525252;}
.changeling				{color: #800080;}
.vox					{color: #aa00aa;}
.rough					{font-family: "Trebuchet MS", cursive, sans-serif;}
.say_quote				{font-family: Georgia, Verdana, sans-serif;}
.adherent				{color: #526c7a;}

.chinese				{color: #d4a52a;}
.indian					{color: #422863;}
.iberian				{color: #ff6600;}
.russian				{color: #9c250b;}
.arabic					{color: #128b11;}
.spacer					{color: #9c660b;}
.selenian       {color: #22228b;}
.lirris					{color: #023638;}
.alain					{color: #6a1b9a;}
.interface				{color: #330033;}

.good                   {color: #4f7529; font-weight: bold;}
.bad                    {color: #ee0000; font-weight: bold;}

.brass					{color: #BE8700;}
.heavy_brass			{color: #BE8700; font-weight: bold; font-style: italic;}
.large_brass			{color: #BE8700; font-size: 24px;}
.big_brass				{color: #BE8700; font-size: 24px; font-weight: bold; font-style: italic;}
.ratvar					{color: #BE8700; font-size: 48px; font-weight: bold; font-style: italic;}
.alloy					{color: #42474D;}
.heavy_alloy			{color: #42474D; font-weight: bold; font-style: italic;}
.nezbere_large			{color: #42474D; font-size: 24px; font-weight: bold; font-style: italic;}
.nezbere				{color: #42474D; font-weight: bold; font-style: italic;}
.nezbere_small			{color: #42474D;}
.sevtug_large			{color: #AF0AAF; font-size: 24px; font-weight: bold; font-style: italic;}
.sevtug					{color: #AF0AAF; font-weight: bold; font-style: italic;}
.sevtug_small			{color: #AF0AAF;}
.inathneq_large			{color: #1E8CE1; font-size: 24px; font-weight: bold; font-style: italic;}
.inathneq				{color: #1E8CE1; font-weight: bold; font-style: italic;}
.inathneq_small			{color: #1E8CE1;}
.nzcrentr_large			{color: #DAAA18; font-size: 24px; font-weight: bold; font-style: italic;}
.nzcrentr				{color: #DAAA18; font-weight: bold; font-style: italic;}
.nzcrentr_small			{color: #DAAA18;}
.neovgre_large			{color: #6E001A; font-size: 24px; font-weight: bold; font-style: italic;}
.neovgre				{color: #6E001A; font-weight: bold; font-style: italic;}
.neovgre_small			{color: #6E001A;}

BIG IMG.icon 			{width: 32px; height: 32px;}

</style>"}
