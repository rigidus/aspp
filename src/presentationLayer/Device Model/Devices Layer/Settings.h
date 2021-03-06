//============================================================================
// Name        : Settings.h
// Author      : aav
// Created on  : 8 февр. 2016 г.
// Version     : v.0.1
// Copyright   : Non nobis, Domine, non nobis, sed nomini tuo da gloriam.
// Description : Setting interface for device and communications
//============================================================================

#ifndef SETTINGS_H_
#define SETTINGS_H_

#include <string>
#include <vector>

#include <boost/cstdint.hpp>

namespace settings {

using namespace boost;

	struct AllDeviceConf
	{
		std::string conName;
		std::string abstractName;
		std::string proto;
		std::vector<std::string> comm;
		bool enable;
	};

	struct DeviceConfig
	{
		std::string concreteName;
		std::string abstractName;
		std::string proto;
		std::vector<std::string> comm;
		bool enable;
	};

	struct CommGPIOConfig
	{
		std::string name;
		bool direction; // 0 - in, 1 - out
		bool def_value;		// 0 - off 1 - on
		uint32_t pulseLen;
	};

	struct CommUARTConfig
	{
		std::string name;
		uint32_t speed;
		uint32_t bits;
		uint32_t stop;
		bool even;
	};

	struct CommCharDevConfig
	{
		std::string name;
		std::string path;
	};

	struct CommDisplayConfig
	{
		std::string name;
		std::string path;
	};

	struct CommPrinterConfig
	{
		std::string name;
		std::string path;
	};

	struct HttpClientConfig
	{
		std::string name;
		std::string host;
		std::string port;
	};

	const std::vector<DeviceConfig> getDeviceConfig();

	const std::vector<std::string> getCommNamesByDevice(const std::string& deviceName);
	const std::vector<CommGPIOConfig> getGPIOByDevice(const std::string deviceName, const std::string gpioName);
	const std::vector<CommUARTConfig> getUARTByDevice(const std::string deviceName);
	const std::vector<CommDisplayConfig> getDisplayByDevice(const std::string deviceName);
	const std::vector<CommPrinterConfig> getPrinterByDevice(const std::string deviceName);
	const std::vector<CommCharDevConfig> getCharDevsByDevice(const std::string deviceName);

	extern std::vector<DeviceConfig*> deviceList;
	extern std::vector<CommGPIOConfig*> gpioConfigList;
	extern std::vector<CommUARTConfig*> uartConfigList;
	extern std::vector<CommDisplayConfig*> displayConfigList;
	extern std::vector<CommPrinterConfig*> printerConfigList;
	extern std::vector<CommCharDevConfig*> chardevsConfigList;

} /* namespace database */

#endif /* SETTINGS_H_ */
