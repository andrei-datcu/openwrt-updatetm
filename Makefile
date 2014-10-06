#
# Copyright (C) 2014 Andrei Datcu <datcuandrei@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# 

include $(TOPDIR)/rules.mk

PKG_NAME:=updatetacho
PKG_VERSION:=1.75
PKG_USE_MIPS16:=0 

PKG_BUILD_DEPENDS:=+qt5-core +qt5-network +qt5-concurrent +qt5-sql

include $(INCLUDE_DIR)/package.mk
$(call	include_mk, cmake.mk)

define 	Package/updatetacho
  CATEGORY:=utils
  SECTION:=Servers
  TITLE:=updatetacho
  DEPENDS:=+qt5-core +qt5-network +qt5-concurrent +qt5-sql
endef

ifeq ($(CONFIG_CCACHE),)
  CMAKE_C_COMPILER:=$(TOOLCHAIN_DIR)/bin/$(TARGET_CC)
  CMAKE_C_COMPILER_ARG1:=
  CMAKE_CXX_COMPILER:=$(TOOLCHAIN_DIR)/bin/$(TARGET_CXX)
  CMAKE_CXX_COMPILER_ARG1:=
else
  CMAKE_C_COMPILER:=$(STAGING_DIR_HOST)/bin/ccache
  CMAKE_C_COMPILER_ARG1:=$(filter-out ccache,$(TARGET_CC))
  CMAKE_CXX_COMPILER:=$(STAGING_DIR_HOST)/bin/ccache
  CMAKE_CXX_COMPILER_ARG1:=$(filter-out ccache,$(TARGET_CXX))
endif 

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/src
	$(CP) ./src/* $(PKG_BUILD_DIR)/src/
endef

define Build/Configure
	$(CP) ./files/CMakeLists.txt $(PKG_BUILD_DIR)
	( cd $(PKG_BUILD_DIR); \
	CFLAGS="$(TARGET_CFLAGS) $(EXTRA_CFLAGS)" \
	CXXFLAGS="$(TARGET_CFLAGS) $(EXTRA_CFLAGS) -std=c++11" \
	LD_LIBRARY_PATH="$(TARGET_LIBDIRS) $(STAGING_DIR)/usr/lib/" \
	cmake \
		-DCMAKE_SYSTEM_NAME=Linux \
		-DCMAKE_SYSTEM_VERSION=1 \
		-DCMAKE_SYSTEM_PROCESSOR=$(ARCH) \
		-DCMAKE_BUILD_TYPE=Debug \
		-DCMAKE_C_FLAGS_RELEASE="-DNDEBUG" \
		-DCMAKE_CXX_FLAGS_RELEASE="-DNDEBUG" \
		-DCMAKE_RUNTIME_OUTPUT_DIRECTORY="$(PKG_INSTALL_DIR)" \
		-DCMAKE_C_COMPILER="$(CMAKE_C_COMPILER)" \
		-DCMAKE_C_COMPILER_ARG1="$(CMAKE_C_COMPILER_ARG1)" \
		-DCMAKE_CXX_COMPILER="$(CMAKE_CXX_COMPILER)" \
		-DCMAKE_CXX_COMPILER_ARG1="$(CMAKE_CXX_COMPILER_ARG1)" \
		-DCMAKE_EXE_LINKER_FLAGS="$(TARGET_LDFLAGS)" \
		-DCMAKE_MODULE_LINKER_FLAGS="$(TARGET_LDFLAGS)" \
		-DCMAKE_SHARED_LINKER_FLAGS="$(TARGET_LDFLAGS)" \
		-DCMAKE_FIND_ROOT_PATH=$(STAGING_DIR) \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=BOTH \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_STRIP=: \
		-DCMAKE_INSTALL_PREFIX=/usr \
		$(CMAKE_OPTIONS) \
		. \
	)
endef

define Package/updatetacho/install
	$(INSTALL_DIR) $(1)/usr/bin
	
	$(INSTALL_BIN) \
		$(PKG_INSTALL_DIR)/updatetacho \
		$(1)/usr/bin/
endef

$(eval $(call BuildPackage,updatetacho))
