/*
 * device_config.h
 *
 *  Created on: 8 февр. 2016 г.
 *      Author: alex
 */

#include <Settings.h>

#define enabled_device	true
#define disabled_device false

settings::DeviceConfig client_http =
{
		"logic_http",
		"logic_bsns_layer",
		"",
		{  },
		enabled_device
};

settings::DeviceConfig client_http_dev_layer =
{
		"logic_http_dev_layer",
		"logic_dev_layer",
		"",
		{  },
		enabled_device
};

settings::DeviceConfig test_device =
{
		"concrete_device",
		"abstract_device",
		"",
		{  },
		enabled_device
};

settings::DeviceConfig shlagbaum1 =
{
		"shlagbaum_gpio",
		"shlagbaum_in",
		"",
		// (in, out) - UP, (in. out) - DOWN, in - car present
		{ "gpio66", "gpio67", "gpio68", "gpio69", "gpio45" },
		enabled_device
};

settings::DeviceConfig printer =
{
		"pechatalka_ru",
		"printer",
		"printer_proto",
		{"uart4"},
		disabled_device
};

settings::DeviceConfig display =
{
		"display_ru",
		"display_winstar_4x16",
		"",
		{ },
		disabled_device
};

settings::DeviceConfig userbutton =
{
		"user-button",
		"user-button",
		"",
		{ "gpio44" },
		enabled_device
};

settings::DeviceConfig* devices[] =
{
		&client_http,
		&client_http_dev_layer,
		&test_device,
		&shlagbaum1,
		&printer,
		&display,
		&userbutton
};

settings::CommGPIOConfig gpio66 =
{
		"gpio66",
		false,	// in, UP
		false,	// value = 0
		3000	// default pulse value, ms
};

settings::CommGPIOConfig gpio67 =
{
		"gpio67",
		true,	// out, UP
		false,	// value = 0
		3000	// default pulse value, ms
};

settings::CommGPIOConfig gpio68 =
{
		"gpio68",
		false,	// in, DOWN
		false,	// value = 1
		300		// check delay, ms
};

settings::CommGPIOConfig gpio69 =
{
		"gpio69",
		true,	// out, DOWN
		false,	// value = 1
		300		// check delay, ms
};

settings::CommGPIOConfig gpio45 =
{
		"gpio45",
		false,	// in, signal from car present
		true,	// value = 1
		300		// check delay, ms
};

settings::CommGPIOConfig gpio44 =
{
		"gpio44",
		false,	// in, signal from user button
		true,	// value = 1
		300		// check delay, ms
};

settings::CommUARTConfig uart2 =
{
		"uart2",
		115200,
		8, 1, true
};

settings::CommGPIOConfig* gpioConfigs[] =
{
		&gpio66,
		&gpio67,
		&gpio68,
		&gpio69,
		&gpio45,
		&gpio44
};

settings::CommUARTConfig* uartConfigs[] =
{
		&uart2
};

std::vector<settings::CommGPIOConfig*> settings::gpioConfigList(gpioConfigs, &gpioConfigs[sizeof(gpioConfigs)/sizeof(gpioConfigs[0])]);
std::vector<settings::CommUARTConfig*> settings::uartConfigList(uartConfigs, &uartConfigs[sizeof(uartConfigs)/sizeof(uartConfigs[0])]);
std::vector<settings::DeviceConfig*> settings::deviceList(devices, &devices[sizeof(devices)/sizeof(devices[0])]);

