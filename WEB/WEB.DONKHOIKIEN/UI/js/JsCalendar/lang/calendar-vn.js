
// Distributed under the same terms as the calendar itself.

// For translators: please use UTF-8 if possible.  We strongly believe that
// Unicode is the answer to a real internationalized world.  Also please
// include your contact information in the header, as can be seen above.

// full day names
Calendar._DN = new Array
("CN",
 "Thứ 2",
 "Thứ 3",
 "Thứ 4",
 "Thứ 5",
 "Thứ 6",
 "Thứ 7",
 "CN");


// Please note that the following array of short day names (and the same goes
// for short month names, _SMN) isn't absolutely necessary.  We give it here
// for exemplification on how one can customize the short day names, but if
// they are simply the first N letters of the full name you can simply say:
//
//   Calendar._SDN_len = N; // short day name length
//   Calendar._SMN_len = N; // short month name length
//
// If N = 3 then this is not needed either since we assume a value of 3 if not
// present, to be compatible with translation files that were written before
// this feature.

// short day names
Calendar._SDN = new Array
("CN",
 "2",
 "3",
 "4",
 "5",
 "6",
 "7",
 "CN");


// First day of the week. "0" means display Sunday first, "1" means display
// Monday first, etc.
Calendar._FD = 0;

// full month names
Calendar._MN = new Array
("Tháng 1",
 "Tháng 2",
 "Tháng 3",
 "Tháng 4",
 "Tháng 5",
 "Tháng 6",
 "Tháng 7",
 "Tháng 8",
 "Tháng 9",
 "Tháng 10",
 "Tháng 11",
 "Tháng 12");

// short month names
Calendar._SMN = new Array
("Tháng 1",
 "Tháng 2",
 "Tháng 3",
 "Tháng 4",
 "Tháng 5",
 "Tháng 6",
 "Tháng 7",
 "Tháng 8",
 "Tháng 9",
 "Tháng 10",
 "Tháng 11",
 "Tháng 12");

// tooltips
Calendar._TT = {};
Calendar._TT["INFO"] = "Trợ giúp";

Calendar._TT["ABOUT"] =
"Trợ giúp sử dụng hộp chọn thời gian:\n\n" +
"   * Để chọn ngày tháng: \n" +
"   - Sử dụng phím " + String.fromCharCode(0x2039) + " , " + String.fromCharCode(0x203a) + " để chọn tháng\n" +
"   - Sử dụng phím " + String.fromCharCode(0x2039)+ String.fromCharCode(0x2039)+ " , " + String.fromCharCode(0x203a)  + String.fromCharCode(0x203a)+ " để chọn năm\n" +
"   - Giữ một phím để chọn liên tục.";
Calendar._TT["ABOUT_TIME"] = "\n\n" +
"   * Để chọn khoảng thời gian:\n" +
"   - Bấm vào bất kì khoảng thời gian nào để thay đổi thời gian\n" +
"   - hoặc ấn (Shift + ấn chọn thời gian) để chọn thời gian giảm dần\n" +
"   - Giữ một phím để tốc độ chọn nhanh hơn.";

Calendar._TT["PREV_YEAR"] = "Năm trước";
Calendar._TT["PREV_MONTH"] = "Tháng trước";
Calendar._TT["GO_TODAY"] = "Chọn ngày hôm nay";
Calendar._TT["NEXT_MONTH"] = "Tháng tiếp theo";
Calendar._TT["NEXT_YEAR"] = "Năm tiếp theo";
Calendar._TT["SEL_DATE"] = "Chọn ngày";
Calendar._TT["DRAG_TO_MOVE"] = "Kéo di chuyển";
Calendar._TT["PART_TODAY"] = " (Hôm nay)";

// the following is to inform that "%s" is to be the first day of week
// %s will be replaced with the day name.
Calendar._TT["DAY_FIRST"] = "%s";

// This may be locale-dependent.  It specifies the week-end days, as an array
// of comma-separated numbers.  The numbers are from 0 to 6: 0 means Sunday, 1
// means Monday, etc.
Calendar._TT["WEEKEND"] = "0,6";

Calendar._TT["CLOSE"] = "Đóng hộp chọn";
Calendar._TT["TODAY"] = "Hôm nay";
Calendar._TT["TIME_PART"] = "Bấm vào để chọn thời gian";

// date formats
Calendar._TT["DEF_DATE_FORMAT"] = "%d/%m/%Y";
Calendar._TT["TT_DATE_FORMAT"] = "Thứ %a, Ngày %e  %b  Năm %Y";

Calendar._TT["WK"] = "Tuần\Thứ";
Calendar._TT["TIME"] = "Thời gian:";
