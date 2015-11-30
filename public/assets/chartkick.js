/*
 * Chartkick.js
 * Create beautiful Javascript charts with minimal code
 * https://github.com/ankane/chartkick.js
 * v1.0.2
 * MIT License
 */
/*jslint browser: true, indent: 2, plusplus: true */
/*global google, $*/
(function(){"use strict";function e(e){return Object.prototype.toString.call(e)==="[object Array]"}function t(e){return e instanceof Object}function n(r,i){var s;for(s in i)t(i[s])||e(i[s])?(t(i[s])&&!t(r[s])&&(r[s]={}),e(i[s])&&!e(r[s])&&(r[s]=[]),n(r[s],i[s])):i[s]!==undefined&&(r[s]=i[s])}function r(e,t){var r={};return n(r,e),n(r,t),r}function o(e){var t,n,r,o,u,a,f,l,c,h,p;h=Object.prototype.toString.call(e);if(h==="[object Date]")return e;if(h!=="[object String]")return;if(r=e.match(i))return p=parseInt(r[1],10),a=parseInt(r[3],10)-1,t=parseInt(r[5],10),n=parseInt(r[7],10),u=r[9]?parseInt(r[9],10):0,c=r[11]?parseInt(r[11],10):0,o=r[12]?parseFloat(s+r[12].slice(1))*1e3:0,l=Date.UTC(p,a,t,n,u,c,o),r[13]&&r[14]&&(f=r[15]*60,r[17]&&(f+=parseInt(r[17],10)),f*=r[14]==="-"?-1:1,l-=f*60*1e3),new Date(l)}function u(e){var t,n,r;for(t=0;t<e.length;t++){r=e[t].data;for(n=0;n<r.length;n++)if(r[n][1]<0)return!0}return!1}function a(e,t,n,i){return function(s,o){var a=r({},e);return o.hideLegend&&t(a),"min"in o?n(a,o.min):u(s)||n(a,0),"max"in o&&i(a,o.max),a=r(a,o.library||{}),a}}function w(e,t){document.body.innerText?e.innerText=t:e.textContent=t}function E(e,t){w(e,"Error Loading Chart: "+t),e.style.color="#ff0000"}function S(e,t,n){$.ajax({dataType:"json",url:t,success:n,error:function(t,n,r){var i=typeof r=="string"?r:r.message;E(e,i)}})}function x(e,t,n,r){try{r(e,t,n)}catch(i){throw E(e,i.message),i}}function T(e,t,n,r){typeof t=="string"?S(e,t,function(t,i,s){x(e,t,n,r)}):x(e,t,n,r)}function N(e){return""+e}function C(e){return parseFloat(e)}function k(e){if(typeof e!="object")if(typeof e=="number")e=new Date(e*1e3);else{var t=e.replace(/ /,"T").replace(" ","").replace("UTC","Z");e=o(t)||new Date(e)}return e}function L(t){if(!e(t)){var n=[],r;for(r in t)t.hasOwnProperty(r)&&n.push([r,t[r]]);t=n}return t}function A(e,t){return e[0].getTime()-t[0].getTime()}function O(t,n,r){var i,s,o,u,a;!e(t)||typeof t[0]!="object"||e(t[0])?(t=[{name:"Value",data:t}],n.hideLegend=!0):n.hideLegend=!1;for(i=0;i<t.length;i++){o=L(t[i].data),u=[];for(s=0;s<o.length;s++)a=o[s][0],a=r?k(a):N(a),u.push([a,C(o[s][1])]);r&&u.sort(A),t[i].data=u}return t}function M(e,t,n){f(e,O(t,n,!0),n)}function _(e,t,n){c(e,O(t,n,!1),n)}function D(e,t,n){var r=L(t),i;for(i=0;i<r.length;i++)r[i]=[N(r[i][0]),C(r[i][1])];l(e,r,n)}function P(e,t,n,r){typeof e=="string"&&(e=document.getElementById(e)),T(e,t,n||{},r)}var i=/(\d\d\d\d)(\-)?(\d\d)(\-)?(\d\d)(T)?(\d\d)(:)?(\d\d)?(:)?(\d\d)?([\.,]\d+)?($|Z|([\+\-])(\d\d)(:)?(\d\d)?)/i,s=String(1.5).charAt(1),f,l,c;if("Highcharts"in window){var h={xAxis:{labels:{style:{fontSize:"12px"}}},yAxis:{title:{text:null},labels:{style:{fontSize:"12px"}}},title:{text:null},credits:{enabled:!1},legend:{borderWidth:0},tooltip:{style:{fontSize:"12px"}}},p=function(e){e.legend.enabled=!1},d=function(e,t){e.yAxis.min=t},v=function(e,t){e.yAxis.max=t},m=a(h,p,d,v);f=function(e,t,n){var r=m(t,n),i,s,o;r.xAxis.type="datetime",r.chart={type:"spline",renderTo:e.id};for(s=0;s<t.length;s++){i=t[s].data;for(o=0;o<i.length;o++)i[o][0]=i[o][0].getTime();t[s].marker={symbol:"circle"}}r.series=t,new Highcharts.Chart(r)},l=function(e,t,n){var i=r(h,n.library||{});i.chart={renderTo:e.id},i.series=[{type:"pie",name:"Value",data:t}],new Highcharts.Chart(i)},c=function(e,t,n){var r=m(t,n),i,s,o,u,a=[];r.chart={type:"column",renderTo:e.id};for(i=0;i<t.length;i++){o=t[i];for(s=0;s<o.data.length;s++)u=o.data[s],a[u[0]]||(a[u[0]]=new Array(t.length)),a[u[0]][i]=u[1]}var f=[];for(i in a)a.hasOwnProperty(i)&&f.push(i);r.xAxis.categories=f;var l=[];for(i=0;i<t.length;i++){u=[];for(s=0;s<f.length;s++)u.push(a[f[s]][i]);l.push({name:t[i].name,data:u})}r.series=l,new Highcharts.Chart(r)}}else if("google"in window){var g=!1;google.setOnLoadCallback(function(){g=!0}),google.load("visualization","1.0",{packages:["corechart"]});var y=function(e){google.setOnLoadCallback(e),g&&e()},h={fontName:"'Lucida Grande', 'Lucida Sans Unicode', Verdana, Arial, Helvetica, sans-serif",pointSize:6,legend:{textStyle:{fontSize:12,color:"#444"},alignment:"center",position:"right"},curveType:"function",hAxis:{textStyle:{color:"#666",fontSize:12},gridlines:{color:"transparent"},baselineColor:"#ccc"},vAxis:{textStyle:{color:"#666",fontSize:12},baselineColor:"#ccc",viewWindow:{}},tooltip:{textStyle:{color:"#666",fontSize:12}}},p=function(e){e.legend.position="none"},d=function(e,t){e.vAxis.viewWindow.min=t},v=function(e,t){e.vAxis.viewWindow.max=t},m=a(h,p,d,v),b=function(e,t){var n=new google.visualization.DataTable;n.addColumn(t,"");var r,i,s,o,u,a=[];for(r=0;r<e.length;r++){s=e[r],n.addColumn("number",s.name);for(i=0;i<s.data.length;i++)o=s.data[i],u=t==="datetime"?o[0].getTime():o[0],a[u]||(a[u]=new Array(e.length)),a[u][r]=C(o[1])}var f=[];for(r in a)a.hasOwnProperty(r)&&f.push([t==="datetime"?new Date(C(r)):r].concat(a[r]));return t==="datetime"&&f.sort(A),n.addRows(f),n};f=function(e,t,n){y(function(){var r=m(t,n),i=b(t,"datetime"),s=new google.visualization.LineChart(e);s.draw(i,r)})},l=function(e,t,n){y(function(){var i=r(h,n.library||{});i.chartArea={top:"10%",height:"80%"};var s=new google.visualization.DataTable;s.addColumn("string",""),s.addColumn("number","Value"),s.addRows(t);var o=new google.visualization.PieChart(e);o.draw(s,i)})},c=function(e,t,n){y(function(){var r=m(t,n),i=b(t,"string"),s=new google.visualization.ColumnChart(e);s.draw(i,r)})}}else f=l=c=function(){throw new Error("Please install Google Charts or Highcharts")};var H={LineChart:function(e,t,n){P(e,t,n,M)},ColumnChart:function(e,t,n){P(e,t,n,_)},PieChart:function(e,t,n){P(e,t,n,D)}};window.Chartkick=H})();