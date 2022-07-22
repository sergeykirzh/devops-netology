<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wordpress' );

/** Database password */
define( 'DB_PASSWORD', 'wordpress' );

/** Database hostname */
define( 'DB_HOST', '192.168.50.10' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '4v-Dlth%7y[:Yyn-k?$n(P+~[dsk!OxvC?e2+@h4q)`tTP,7lh727DW>[!2CU?De' );
define( 'SECURE_AUTH_KEY',  '-pNc/#|3E^KY1. +G2b1RJ@!2#.j;qvPAKEt5&8n%a;qJP3Cbt10gYTaJgO7B0y)' );
define( 'LOGGED_IN_KEY',    'g&!(!vP4-{2K2g(52/c0meS?SJrA?O,aFE+2)AP1Aw5JDV9o!p$i]B#C]v(jg#uD' );
define( 'NONCE_KEY',        'D$I*3T2^fF#@q9)$z7nDLvm52/8f.D?IwC$/wbMI+ck^B77`! #4%bd[*=WD.R#B' );
define( 'AUTH_SALT',        '~W8QVIc`R?NBvCgL/3@{.m ,:hP00 $]5t,`>oCVR4M[6HhCfH2g~FvrU>TZC%Z|' );
define( 'SECURE_AUTH_SALT', 'a7S6*dcl!rzk&jXOhQp%j`4d){2,]e[7 $g{yx=v.iC;h.+0w~c|SBLNOUPxkn>`' );
define( 'LOGGED_IN_SALT',   'B?P^eY^{.E9T|CFCqr{,,sOGQ`h ^;HH;14;YF_zG m/7>3uiv7`_}/ED=phD{Jw' );
define( 'NONCE_SALT',       'Gk-7.ph@],0w%?i8&AYb3vaPr]uT:D 5-&fRr<  *}Rs&{3:Z!o6?:rQCCkXN<rT' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
