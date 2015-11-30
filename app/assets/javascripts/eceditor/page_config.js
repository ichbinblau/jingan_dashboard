var PageSetConfig = {};
PageSetConfig.MethodList = [];
PageSetConfig.XTypeConfig = [
  {
      "xtype": "ECButtonWidget",
      "setEvent": [{ "name": "buttonClick" }, { "name": "buttonLongClick" }]
  },
  {
      "xtype": "ActionBarWidget",
      "setEvent": [{ "name": "optionItemClick" }, { "name": "navItemClick" }, { "name": "queryText" }, { "name": "channelTabChanged" }, { "name": "customItemClick" }]
  },
  {
      "xtype": "ListViewWidget",
      "setEvent": [{ "name": "itemClick" }, { "name": "refresh" }, { "name": "loadMore" }]
  },
  {
      "xtype": "MapWidget",
      "setEvent": [{ "name": "mapPopupClicked" }, { "name": "myLocationOverlayClicked" }]
  },
  {
      "xtype": "ItemNewsWidget",
      "setEvent": [{ "name": "click" }, { "name": "buttonClick" }]
  },
  {
      "xtype": "GroupWidget",
      "setEvent": [{ "name": "groupItemClick" }]
  }
];
PageSetConfig.KeyValObj = [
  { name: "key", type: "string" , cls: "input-mini" },
  { name: "value", type: "string" ,cls: "input-medium"},
  { name: "defaultValue", type: "string",cls: "input-mini"}
];
PageSetConfig.datasource = {
  name: "datasource",
  type: "object",
  data: "json",
  fields: [
      { name: "method", type: "string" , cls: "data-method"},
      { name: "data", type: "json" , cls: "ace_json"},
      {
          name: "params",
          type: "array",
          mode: "column",
          fields: PageSetConfig.KeyValObj

      },
      {
          name: "adapter",
          type: "array",
          mode: "column",
          fields: PageSetConfig.KeyValObj

      }
  ]
};
PageSetConfig.setEvent = {
  name: "setEvent",
  type: "array",
  member: {
      type: "object",
      fields: [
          { name: "name", type: "string", cls: "live-event" },
          { name: "id", type: "string"},
          {
              name: "params",
              type: "array",
              mode: "column",
              fields: PageSetConfig.KeyValObj
          },
          { name: "javascript", type: "text" , cls: "ace_javascript"}
      ]
  }
};
PageSetConfig.FieldSetConfig = [
  { name: "control_id" ,cls: "input-xxlarge live-controlid" },
  { name: "xtype", cls: "live-xtype input-xxlarge" },
  { name: "layout" ,cls: "input-xxlarge"},
  PageSetConfig.datasource,
  PageSetConfig.setEvent,
  {
      name: "position",
      type: "array",
      member: {
          mode: "column",
          type: "object",
          fields: PageSetConfig.KeyValObj
      }

  },
  {
      name: "attr",
      type: "array",
      member: {
          type: "object",
          mode: "column",
          fields: PageSetConfig.KeyValObj
      }
  },
  {
      name: "configs",
      type: "array",
      member: {
          mode: "column",
          fields: PageSetConfig.KeyValObj
      }
  }
];
PageSetConfig.PageSetConfig = [
  { name: "name", type: "string" ,cls: "input-xxlarge"},
  { name: "page_id", type: "string" ,cls: "input-xxlarge"},
  PageSetConfig.datasource,
  PageSetConfig.setEvent,
  {
     name: "configs",
     type: "array",
     member: {
         mode: "column",
         fields: PageSetConfig.KeyValObj
     }
  },
  { name: "auto_start_controls", type: "array", member: { type: "string" ,cls: "control_sel"} }
    //{ name: "controls", type: "array", memberType: "object", member: [] }
];


