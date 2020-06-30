#!/usr/bin/env python3
# 
#       SMP Downloader
#
#       License:        GNU General Public License (GPL)
#       (c) 2019        Microsoft Corp.
#

class Package(object):
    selector_newest = 'max(range(len(results)), key=lambda index: results[index]["ReleaseDate"])'
    selector_oldest = 'min(range(len(results)), key=lambda index: results[index]["ReleaseDate"])'
    dir_db          = "DB"
    dir_app         = "APP"
    dir_rti         = "RTI"
    os_linux        = "LINUX_X64"
    os_windows      = "NT_X64"
    os_indep        = "OSINDEP"
    
    def __init__(self, name=None, target_dir=None, retr_params=None, condition=None, filter=None, os_avail=None, os_var=None, selector=None):
        self.name        = name if name else ""
        self.target_dir  = target_dir if target_dir else ""
        self.retr_params = retr_params if retr_params else ""
        self.condition   = condition if condition else []
        self.filter      = filter if filter else []
        self.os_avail    = os_avail if os_avail else []
        self.os_var      = os_var if os_var else ""
        self.selector    = selector if selector else ""

class Scenario(object):
    def __init__(self, name=None, required_params=None, packages=None):
        self.name            = name
        self.required_params = required_params if required_params else []
        self.packages        = packages if packages else []

class DBScenario(Scenario):
    def __init__(self, **kwargs):
        super(DBComponent, self).__init__(**kwargs)

S4 = Scenario(
    required_params = [],
    packages = [
    ],
)

RTI = Scenario(
    required_params = [],
    packages = [
        Package(
            name        = "SAPCAR",
            target_dir  = Package.dir_rti,
            retr_params = {"ENR": "67838200100200019185"},
            os_avail    = [Package.os_linux, Package.os_windows],
            os_var      = 'rti.os_type',
            selector    = Package.selector_newest,
        ),
    ],
)

HDB = Scenario(
    required_params = [
        "product_version",
    ],
    packages = [
        #  _    _          _   _            __   ___  
        # | |  | |   /\   | \ | |   /\     /_ | / _ \ 
        # | |__| |  /  \  |  \| |  /  \     | || | | |
        # |  __  | / /\ \ | . ` | / /\ \    | || | | |
        # | |  | |/ ____ \| |\  |/ ____ \   | || |_| |
        # |_|  |_/_/    \_\_| \_/_/    \_\  |_(_)___/ 
        #                                             
        #############################################################
        # HANA Platform 1.0
        Package(
            name        = "IMDB_PLATFORM100",
            target_dir  = Package.dir_db,
            retr_params = {"ENR": "01200314690900003484", "SWTYPSC":  "N", "PECCLSC":  "NONE", "V":  "INST", "TA": "ACTUAL"},
            condition   = ['db.product_version == "1.0"', '"PLATFORM" in db.components'],
            filter      = ['"1.0" in r["Description"]', '"SAP HANA Platf" in r["Description"]','"ZIP" in r["Infotype"]'],
            os_avail    = [Package.os_indep],
            os_var      = 'Package.os_indep',
            selector    = Package.selector_newest,
        ),                            
        # HANA Database 1.0 (Linux only)
        Package(
            name        = "IMDB_SERVER100",
            target_dir  = Package.dir_db,
            retr_params = {"ENR": "01200615320200017790"},
            condition   = ['db.product_version == "1.0"', '"DATABASE" in db.components'],
            filter      = ['"Maintenance Revision" in r["Description"]'],
            os_avail    = [Package.os_linux],
            os_var      = 'Package.os_linux',
            selector    = Package.selector_newest,
        ),
        #############################################################
        # HANA Client for HANA 1.0 (Windows/Linux)
        Package(
            name        = "IMDB_CLIENT100",
            target_dir  = Package.dir_app,
            retr_params = {"ENR": "01200615320200017866"},
            condition   = ['db.product_version == "1.0"', '"CLIENT" in db.components'],
            filter      = None,
            os_avail    = [Package.os_linux, Package.os_windows],
            os_var      = 'app.os_type',
            selector    = Package.selector_newest,
        ),
        #############################################################
        # HANA Studio for HANA 1.0 (Windows/Linux)
        Package(
            name        = "IMC_STUDIO1",
            target_dir  = Package.dir_db,
            retr_params = {"ENR": "73554900100200000585"},
            condition   = ['db.product_version == "1.0"', '"STUDIO" in db.components'],
            filter      = ['"Revision 1" in r["Description"]'],
            os_avail    = [Package.os_linux, Package.os_windows],
            os_var      = 'Config.bastion_os',
            selector    = Package.selector_newest,
        ),
        #  _    _          _   _            ___    ___  
        # | |  | |   /\   | \ | |   /\     |__ \  / _ \ 
        # | |__| |  /  \  |  \| |  /  \       ) || | | |
        # |  __  | / /\ \ | . ` | / /\ \     / / | | | |
        # | |  | |/ ____ \| |\  |/ ____ \   / /_ | |_| |
        # |_|  |_/_/    \_\_| \_/_/    \_\ |____(_)___/ 
        #                                               
        #############################################################
        # HANA Platform 2.0
        Package(
            name        = "IMDB_PLATFORM200",
            target_dir  = Package.dir_db,
            retr_params = {"ENR": "73554900100900001301", "SWTYPSC":  "N", "PECCLSC":  "NONE", "V":  "INST", "TA": "ACTUAL"},
            condition   = ['db.product_version == "2.0"', '"PLATFORM" in db.components'],
            filter      = ['"2.0" in r["Description"]', '"86_64" in r["Description"]','"ZIP" in r["Infotype"]'],
            os_avail    = [Package.os_indep],
            os_var      = 'Package.os_indep',
            selector    = Package.selector_newest,
        ),
        # HANA Database 2.0 (Linux only)
        Package(
            name        = "IMDB_SERVER200",
            target_dir  = Package.dir_db,
            retr_params = {"ENR": "73554900100200005327"},
            condition   = ['db.product_version == "2.0"', '"DATABASE" in db.components'],
            filter      = ['"Revision" in r["Description"]'],
            os_avail    = [Package.os_linux],
            os_var      = 'Package.os_linux',
            selector    = Package.selector_newest,
        ),
        #############################################################
        # HANA Client for HANA 2.0 (Windows/Linux)
        Package(
            name        = "IMDB_CLIENT20-NT_X64",
            target_dir  = Package.dir_app,
            retr_params = {"ENR": "73554900100200005390"},
            condition   = ['db.product_version == "2.0"', '"CLIENT" in db.components'],
            filter      = None,
            os_avail    = [Package.os_linux, Package.os_windows],
            os_var      = 'app.os_type',
            selector    = Package.selector_newest,
        ),
        #############################################################
        # HANA Studio for HANA 2.0 (Windows/Linux)
        Package(
            name        = "IMC_STUDIO2-NT_X64",
            target_dir  = Package.dir_db,
            retr_params = {"ENR": "73554900100200000585"},
            condition   = ['db.product_version == "2.0"', '"STUDIO" in db.components'],
            filter      = ['"Revision 2" in r["Description"]'],
            os_avail    = [Package.os_linux, Package.os_windows],
            os_var      = 'Config.bastion_os',
            selector    = Package.selector_newest,
        ),
        # __   __ _____         
        # \ \ / // ____|  /\    
        #  \ V /| (___   /  \   
        #   > <  \___ \ / /\ \  
        #  / . \ ____) / ____ \ 
        # /_/ \_\_____/_/    \_\
        #
        #############################################################
        # XS Advanced Runtime (SAP Extended App Services)
        Package(
            name        = "EXTAPPSER00P",
            target_dir  = Package.dir_db,
            retr_params = {"ENR": "73555000100200004274"},
            condition   = ['"XSA" in db.components'],
            filter      = None,
            os_avail    = [Package.os_linux],
            os_var      = 'Package.os_linux',
            selector    = Package.selector_newest,
        ),
        # DI Core
        Package(
            name        = "XSACDEVXDI",
            target_dir  = Package.dir_db,
            retr_params = {
                "ENR"           : "73554900100200003056",
                "PECCLSC"       : "PLTFRM",
                "INCL_PECCLSC2" : "DB",
                "PECGRSC2"      : "HDB"
            },
            condition   = ['"XSA" in db.components'],
            filter      = None,
            os_avail    = [Package.os_indep],
            os_var      = 'Package.os_indep',
            selector    = Package.selector_newest,
        ),
        # SAPUI5 FESV4
        Package(
            name        = "XSACUI5FESV4",
            target_dir  = Package.dir_db,
            retr_params = {"ENR": "73554900100200006811"},
            condition   = ['"XSA" in db.components'],
            filter      = None,
            os_avail    = [Package.os_indep],
            os_var      = 'Package.os_indep',
            selector    = Package.selector_newest,
        ),
    ]
)

avail_apps  = {"S4": S4}
avail_dbs = {"HANA": HDB}
avail_rtis = {"RTI": RTI}
