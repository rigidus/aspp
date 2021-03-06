//============================================================================
// Name        : CPinCtl.h
// Author      : aav
// Created on  : 19 февр. 2016 г.
// Version     : v.0.1
// Copyright   : Non nobis, Domine, non nobis, sed nomini tuo da gloriam.
// Description : Multitone for GPIO resources
//============================================================================

#if !defined(EA_F6FA3185_3A4D_4043_A499_06D6A2FDBFCF__INCLUDED_)
#define EA_F6FA3185_3A4D_4043_A499_06D6A2FDBFCF__INCLUDED_

#include "CBaseCommCtl.h"
#include "devices/CBaseDevice.h"
#include "GlobalThreadPool.h"

#include <iostream>
#include <map>
#include <boost/asio.hpp>
#include <boost/thread.hpp>
#include <boost/filesystem.hpp>
#include <boost/iostreams/device/file.hpp>
#include <boost/iostreams/stream.hpp>

namespace io = boost::iostreams;

/*
 * Multitone class controls GPIO interface for interacting with concrete device
 */
class CPinCtl : private CBaseCommCtl
{

	struct TPinData{
		std::string name;
		std::string filename;
		int32_t fd;
		int32_t events;
		int32_t watch;
		int32_t oldvalue;
	};

public:

	/*
	 * Function takes GPIO resourse for concrete device
	 * @param device - pointer to concrete device use for call callback for inform about event from device
	 * @param gpioName - name of the GPIO resourse for taking
	 * @return - pointer to busied resource or nullptr when resourse is busy or not existing
	 */
	static shared_ptr<CBaseCommCtl> takeCommCtl(CBaseDevice* device, const std::string& gpioName);

	/*
	 * Function frees GPIO resource for it can be taking by another device in the future
	 * @param device - pointer to concrete device for control. Device-taker can free GPIO resourse only
	 * @param gpioName - name of the GPIO resourse for free
	 */
	static void freeCommCtl(CBaseDevice* device, const std::string& gpioName);

	virtual ~CPinCtl();

	static const std::string s_name;

	static boost::thread* thrNotify;

	// Thread function for waiting GPIO events
	// тред должен ждать события на пине через интерфейс inotify
	// тред должен как-то управляться из того же места, где
	// будут управляться все треды комм. девайсов
	static void Notifier();

	static void startNotifier();
	static void stopNotifier();

	// CPinCtl public members
	virtual uint32_t send(std::list<std::vector<uint8_t> > sendData);
	virtual uint32_t send(std::vector<uint8_t> sendData);
	int8_t getPinValue();

private:
	CPinCtl(CBaseDevice* device, const settings::CommGPIOConfig& config, TPinData& pinData);

	const settings::CommGPIOConfig m_Config;
	TPinData m_PinData;

	// check existing file on the filesystem
	// It use here for check interface gpio files only
	static bool fileIsExist(const std::string& fileName);
	static settings::CommGPIOConfig getGPIOConfig(CBaseDevice* device, const std::string& gpioName);
	static std::map<std::string, shared_ptr<CBaseCommCtl> > busyPins;

	static const std::string gpioPath;
	static bool stopFlag;

	bool checkFiles();
	void setupGPIO();

	std::filebuf fBuf;
	std::fstream fLog;

	uint32_t m_timeout;


};

#endif // !defined(EA_F6FA3185_3A4D_4043_A499_06D6A2FDBFCF__INCLUDED_)
