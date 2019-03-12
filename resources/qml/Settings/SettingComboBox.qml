// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.3 as UM

import "../Widgets" as Widgets


SettingItem
{
    id: base
    property var focusItem: control

    contents: Widgets.CuraComboBox
    {
        id: control

        model: definition.options
        textRole: "value"

        anchors.fill: parent

        onActivated:
        {
            forceActiveFocus()
            propertyProvider.setPropertyValue("value", definition.options[index].key)
        }

        onActiveFocusChanged:
        {
            if(activeFocus)
            {
                base.focusReceived()
            }
        }

        Keys.onTabPressed:
        {
            base.setActiveFocusToNextSetting(true)
        }

        Keys.onBacktabPressed:
        {
            base.setActiveFocusToNextSetting(false)
        }

        Binding
        {
            target: control
            property: "currentIndex"
            value:
            {
                // FIXME this needs to go away once 'resolve' is combined with 'value' in our data model.
                var value = undefined
                if ((base.resolve != "None") && (base.stackLevel != 0) && (base.stackLevel != 1))
                {
                    // We have a resolve function. Indicates that the setting is not settable per extruder and that
                    // we have to choose between the resolved value (default) and the global value
                    // (if user has explicitly set this).
                    value = base.resolve
                }

                if (value == undefined)
                {
                    value = propertyProvider.properties.value
                }

                for (var i = 0; i < control.model.length; i++)
                {
                    if (control.model[i].key == value)
                    {
                        return i
                    }
                }

                return -1
            }
        }
    }
}
