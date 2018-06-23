<?php
define('DB_NAME', 'wp');
define('DB_USER', 'wp');
define('DB_PASSWORD', 'qwerty');
define('DB_HOST', 'db0');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');
define('AUTH_KEY',         '37b``}xkGIe>/1HJkN%f}{V6Z`MugJiQ(bxgiE+TwK+f f.YwW%DLq7/Wz}~Q3GY');
define('SECURE_AUTH_KEY',  'Cm7I>|CD2&dGw)#%Zn@@)z.v72$*f~[S2+-*2W{STfG@Td4q+3Jg?:0q.1uyBFVS');
define('LOGGED_IN_KEY',    'q`hsAqn7}x72Uk<K|n+Vs_iz8}dl-IdWfJIXKG+fIaPd1&wdydIkcQA%{];w1#[G');
define('NONCE_KEY',        't4LfefiT{89:j<nHRVIt:qK]y|D+WDr#]5|z%}8B+}i`6oTX8|cAq^kln=/A(Spr');
define('AUTH_SALT',        'vh4@yi9jT.Uz)RvA;H*iHX&Zo#/%jGrHt4TY+6#M4iN}VUhsd}-PR>9a>oj/t>hY');
define('SECURE_AUTH_SALT', 'O9ml(v2m{VV1]Y)~lDUcIe%. th)[G=hC,jU:O9u/b*0neV4Bg[.ba1n@M]%5q2j');
define('LOGGED_IN_SALT',   'Q,[EPi~3c!qWhHz`=f?>ID.ODs 7Zvq3uCz)$Cj<)!]#:OIlaD2(;n?pxgy/[+{F');
define('NONCE_SALT',       'qqpYF^a gaS`{T(lZnP0A|e/H44|~ 78H%QS9W&+#0<&tf=G{c@x5kD)L@*-y}# ');
$table_prefix  = 'wp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');
