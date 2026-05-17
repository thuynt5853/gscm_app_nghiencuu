/* Copyright 2017, Chris Youderian, SimpleMaps, http://simplemaps.com
Released under MIT license - https://opensource.org/licenses/MIT
 */
(function (plugin) {

	//Start helper functions
	//IE8 support for index of
	if (!Array.prototype.indexOf) {
		Array.prototype.indexOf = function (needle) {
			for (var i = 0; i < this.length; i++) {
				if (this[i] === needle) {
					return i;
				}
			}
			return -1;
		};
	}
	//docReady in pure JavaScript, source: https://github.com/jfriend00/docReady/blob/master/docready.js, MIT
	(function (funcName, baseObj) {
		funcName = funcName || "docReady";
		baseObj = baseObj || window;
		var readyList = [];
		var readyFired = false;
		var readyEventHandlersInstalled = false;
		function ready() {
			if (!readyFired) {
				readyFired = true;
				for (var i = 0; i < readyList.length; i++) {
					readyList[i].fn.call(window, readyList[i].ctx);
				}
				readyList = [];
			}
		}
		function readyStateChange() {
			if (document.readyState === "complete") {
				ready();
			}
		}
		baseObj[funcName] = function (callback, context) {
			if (readyFired) {
				setTimeout(function () {
					callback(context);
				}, 1);
				return;
			} else {
				readyList.push({
					fn: callback,
					ctx: context
				});
			}
			if (document.readyState === "complete" || !document.attachEvent && document.readyState === "interactive") {
				setTimeout(ready, 1);
			} else if (!readyEventHandlersInstalled) {
				if (document.addEventListener) {
					document.addEventListener("DOMContentLoaded", ready, false);
					window.addEventListener("load", ready, false);
				} else {
					document.attachEvent("onreadystatechange", readyStateChange);
					window.attachEvent("onload", ready);
				}
				readyEventHandlersInstalled = true;
			}
		};
	})("docReady", window);
	//End helper functions

	window[plugin] = function () {
		return {
			map: false,
			on_shift: false,
			selected_color: false,
		}
	}
	()

	docReady(function () {
		var me = window[plugin];
		var map = me.map ? me.map : simplemaps_usmap; //usmap is default
		var on_shift = me.on_shift;
		var selected_color = me.selected_color ? me.selected_color : map.mapdata.main_settings.state_hover_color;
		var selected = [];
		var max = me.max ? me.max : false;
		var original_mapdata = JSON.parse(JSON.stringify(map.mapdata));
		var main_settings = map.mapdata.main_settings;

		function check_mapdata(state) { //make sure a color exists for each state
			if (!map.mapdata.state_specific[state]) {
				map.mapdata.state_specific[state] = {};
			}
			if (!original_mapdata.state_specific[state]) {
				original_mapdata.state_specific[state] = {};
				original_mapdata.state_specific[state].color = 'default'
			} else if (!original_mapdata.state_specific[state].color) {
				original_mapdata.state_specific[state].color = 'default'
			}
		}

		var deselect = function (state) {
			map.states[state].stop(); //prevents fade time from interfering with deselect
			var index = selected.indexOf(state);
			if (index > -1) { //deselect state
				selected.splice(index, 1);
				check_mapdata(state);
				map.mapdata.state_specific[state].color = original_mapdata.state_specific[state].color;
			}
			done(state);
		}

		var check_max = function (state) {
			if (me.max && selected.length >= me.max) {
				var first = selected[0];
				me.deselect(first);
			}
		}

		var select = function (state) {
			var index = selected.indexOf(state);
			if (index < 0) { //make sure a state is selectedable
				check_mapdata(state);
				check_max();
				map.mapdata.state_specific[state].color = me.selected_color;
				selected.push(state);
				 
				done(state);
				
				
			}
		}

		var select_all = function () {
			for (var state in simplemaps_usmap_mapinfo.paths) {
				select(state);
			}
		}

		var deselect_all = function () {
			var length = selected.length
				for (var i = 1; i < length + 1; i++) {
					var id = length - i
						var state = selected[id];
					deselect(state);
				}
		}

		function done(state) {
			map.refresh_state(state);
			me.selected = selected; //update value
		}

		var upon_click = function (state, e) {
			if (me.on_shift) { //select on shift+click
				var evt = e || w.event;
				var length = me.selected.length;
				var index = me.selected.indexOf(state);
				var last_state = me.selected[length - 1];
				if (length == 0) {
					deselect_all();
					me.select(state);
					Show_State_Selected_Info(state);
					SetSelectedDrop(state);
				} else if (length > 0) {
					if (evt.shiftKey) {
						if (index > -1) {
							me.deselect(state);
						} else {
							deselect_all();
							me.select(state);
							Show_State_Selected_Info(state);
							SetSelectedDrop(state);
						}
					} else {
						me.deselect_all(last_state);
						me.select(state);
						Show_State_Selected_Info(state);
						SetSelectedDrop(state);
					}
				}
			} else { //select on click
				var index = selected.indexOf(state);
				if (index > -1) { //deselect state
					deselect(state);
				} else { //select state
					deselect_all();
					select(state);
					Show_State_Selected_Info(state);
					SetSelectedDrop(state);
				}
			}

		}

		map.plugin_hooks.click_state.push(upon_click);

		window[plugin] = function () {
			return {
				//inputs
				map: map,
				on_shift: on_shift,
				selected_color: selected_color,
				max: max,
				//outputs
				selected: selected,
				//methods
				select: select,
				deselect: deselect,
				select_all: select_all,
				deselect_all: deselect_all
			}
		}
		()

		me = window[plugin];
		 var state_list = $("#state_list");
		 var ddlPhamvi = $("#ddlPhamvi");
		 var ddlDonVi = $("#ddlDonVi");
		 ddlDonVi.chosen();
		 ddlPhamvi.chosen();
		 
		var pie_1 = document.getElementById("pie_1");
		var pie_2 = document.getElementById("pie_2");
		var pie_3 = document.getElementById("pie_3");
		var pie_4 = document.getElementById("pie_4");
		var pie_Total = document.getElementById("pie_Total");
		var ltrPie_Title = document.getElementById("ltrPie_Title");
		
		state_list.chosen();
		state_list.change(function () {
			var id = $(this).val();
			Show_State_Selected_Info(id);
			deselect_all();
			if(id!="VNM000" && id!="VNM001" && id!="VNM002" && id!="VNM003" && id!="VNM004")
			{select(id);}
		 });
		
		state_list.change();

		function SetSelectedDrop(id){
			$('#state_list').val(id);
			$('#state_list').trigger("chosen:updated");
		}
		function Show_State_Selected_Info(id){
			for (var state in map.mapdata.state_specific) {
				var key = state;
				var content = map.mapdata.state_specific[state].description;
				var name_state = (map.mapdata.state_specific[state].name).replace("TAND tỉnh ","").replace("TAND thành phố ","").replace("--- ","").replace(" ---","");
				
				if (key == id && content !='') {
					ltrPie_Title.innerHTML = name_state;
					var strArray = (content.replace("<br>", ";").replace("<br>", ";").replace("<br>", ";").replace("<br>", ";")).split(";");
					var regex = /\d+/g;
					
					// responsive
					var pie_1_content = strArray[1].match(regex);
					var length_content = pie_1_content.toString().length;
					if (length_content == 1) {
						pie_1.innerHTML = '<span class="pie_1_No1">' + pie_1_content + '</span>';
					}
					if (length_content == 2) {
						pie_1.innerHTML = '<span class="pie_1_No2">' + pie_1_content + '</span>';
					}
					if (length_content == 3) {
						pie_1.innerHTML = '<span class="pie_1_No3">' + pie_1_content + '</span>';
					}
					if (length_content == 4) {
						pie_1.innerHTML = '<span class="pie_1_No4">' + pie_1_content + '</span>';
					}
					if (length_content == 5) {
						pie_1.innerHTML = '<span class="pie_1_No5">' + pie_1_content + '</span>';
					}
					if (length_content == 6) {
						pie_1.innerHTML = '<span class="pie_1_No6">' + pie_1_content + '</span>';
					}
					// responsive pie_2
					var pie_2_content = strArray[2].match(regex);
					length_content = pie_2_content.toString().length;
					if (length_content == 1) {
						pie_2.innerHTML = '<span class="pie_2_No1">' + pie_2_content + '</span>';
					}
					if (length_content == 2) {
						pie_2.innerHTML = '<span class="pie_2_No2">' + pie_2_content + '</span>';
					}
					if (length_content == 3) {
						pie_2.innerHTML = '<span class="pie_2_No3">' + pie_2_content + '</span>';
					}
					if (length_content == 4) {
						pie_2.innerHTML = '<span class="pie_2_No4">' + pie_2_content + '</span>';
					}
					if (length_content == 5) {
						pie_2.innerHTML = '<span class="pie_2_No5">' + pie_2_content + '</span>';
					}
					if (length_content == 6) {
						pie_2.innerHTML = '<span class="pie_2_No6">' + pie_2_content + '</span>';
					}
					// responsive pie_3
					var pie_3_content = strArray[3].match(regex);
					length_content = pie_3_content.toString().length;
					if (length_content == 1) {
						pie_3.innerHTML = '<span class="pie_3_No1">' + pie_3_content + '</span>';
					}
					if (length_content == 2) {
						pie_3.innerHTML = '<span class="pie_3_No2">' + pie_3_content + '</span>';
					}
					if (length_content == 3) {
						pie_3.innerHTML = '<span class="pie_3_No3">' + pie_3_content + '</span>';
					}
					if (length_content == 4) {
						pie_3.innerHTML = '<span class="pie_3_No4">' + pie_3_content + '</span>';
					}
					if (length_content == 5) {
						pie_3.innerHTML = '<span class="pie_3_No5">' + pie_3_content + '</span>';
					}
					if (length_content == 6) {
						pie_3.innerHTML = '<span class="pie_3_No6">' + pie_3_content + '</span>';
					}
					// responsive pie_4
					var pie_4_content = strArray[4].match(regex);
					length_content = pie_4_content.toString().length;
					if (length_content == 1) {
						pie_4.innerHTML = '<span class="pie_4_No1">' + pie_4_content + '</span>';
					}
					if (length_content == 2) {
						pie_4.innerHTML = '<span class="pie_4_No2">' + pie_4_content + '</span>';
					}
					if (length_content == 3) {
						pie_4.innerHTML = '<span class="pie_4_No3">' + pie_4_content + '</span>';
					}
					if (length_content == 4) {
						pie_4.innerHTML = '<span class="pie_4_No4">' + pie_4_content + '</span>';
					}
					if (length_content == 5) {
						pie_4.innerHTML = '<span class="pie_4_No5">' + pie_4_content + '</span>';
					}
					if (length_content == 6) {
						pie_4.innerHTML = '<span class="pie_4_No6">' + pie_4_content + '</span>';
					}
					// responsive Total
					var Total_content = strArray[0].match(regex);
					length_content = Total_content.toString().length;
					if (length_content == 1) {
						pie_Total.innerHTML = '<span class="pie_Total_No1">' + Total_content + '</span>';
					}
					if (length_content == 2) {
						pie_Total.innerHTML = '<span class="pie_Total_No2">' + Total_content + '</span>';
					}
					if (length_content == 3) {
						pie_Total.innerHTML = '<span class="pie_Total_No3">' + Total_content + '</span>';
					}
					if (length_content == 4) {
						pie_Total.innerHTML = '<span class="pie_Total_No4">' + Total_content + '</span>';
					}
					if (length_content == 5) {
						pie_Total.innerHTML = '<span class="pie_Total_No5">' + Total_content + '</span>';
					}
					if (length_content == 6) {
						pie_Total.innerHTML = '<span class="pie_Total_No6">' + Total_content + '</span>';
					}

				}
			}
		}
	});

})('simplemaps_select'); //change plugin name to use across multiple maps on the same page
