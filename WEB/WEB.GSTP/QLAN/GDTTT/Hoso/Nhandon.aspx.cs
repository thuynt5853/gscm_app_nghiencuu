using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.GSTP.Models;
using WEB.GSTP.QLAN.GDTTT.In;

namespace WEB.GSTP.QLAN.GDTTT.Hoso
{
    public partial class Nhandon : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0, DA_CHUYEN = 0, DA_NHAN = 1;
        private const string CONNECTION_TO_DB_TRUNGGIAN = "DB_TRUNG_GIAN_Connection";
        private decimal UserID = 0;
        public bool GetBool(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch { return false; }
        }
        public string Getdate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return Convert.ToDateTime(obj).ToString("dd/MM/yyyy HH:MM");
            }
            catch { return ""; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                UserID = Session[ENUM_SESSION.SESSION_USERID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                if (!IsPostBack)
                {
                    // Tạm thời COMMENT Chờ kết nối
                    #region Quét các vụ việc được chuyển từ Tòa án cấp cao và lưu vào ADS_DON và ADS_CHUYEN_NHAN_AN
                    //decimal ToaAnID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
                    // TRANG_THAI_CHUYEN(0: chưa nhận; 1: Đã nhận; 2: Trả lại) 
                    //string sql = "select * from CHUYEN_NHAN_DON_GDT where TOA_AN_NHAN='" + ToaAnID.ToString() + " and TRANG_THAI_CHUYEN=0";
                    //DataTable dlChuyenAn = Cls_Comon.GetTableToSQL(CONNECTION_TO_DB_TRUNGGIAN, sql);
                    //if (dlChuyenAn.Rows.Count > 0)
                    //{
                    //    foreach (DataRow row in dlChuyenAn.Rows)
                    //    {
                    //        decimal ToaAn_Chuyen = row["TOA_AN_CHUYEN"] + "" == "" ? 0 : Convert.ToDecimal(row["TOA_AN_CHUYEN"]),
                    //                ToaAn_Nhan = row["TOA_AN_NHAN"] + "" == "" ? 0 : Convert.ToDecimal(row["TOA_AN_NHAN"]);
                    //        /* Bước 1: 
                    //         * Khởi tạo đơn cho Tòa chuyển
                    //         * Thông tin đơn được lấy từ QLACC
                    //         */
                    //        string strThongTinDon = JsonConvert.SerializeObject(row["THONG_TIN_DON"].ToString());
                    //        THONG_TIN_DON TTDon = JsonConvert.DeserializeObject<THONG_TIN_DON>(strThongTinDon);
                    //        if (TTDon != null)
                    //        {
                    //            decimal DonID = UpdateThongTinDon(TTDon, ToaAn_Chuyen);
                    //            // Update Danh sách người đồng khiếu nại
                    //            string strList_DongKhieuNai = JsonConvert.SerializeObject(row["DONGKHIEUNAI"].ToString());
                    //            List<DONGKHIEUNAI> List_DongKhieuNai = JsonConvert.DeserializeObject<List<DONGKHIEUNAI>>(strList_DongKhieuNai);
                    //            Update_DongKhieuNai(DonID, List_DongKhieuNai);
                    //            /* Bước 2:
                    //             * Lưu thông tin đơn vừa tạo vào bảng GDTTT_DON_CHUYEN với đơn vị chuyển là Tòa chuyển, đơn vị nhận là Tòa nhận
                    //             * Để khi Tòa nhận login và truy cập chức năng:
                    //             * "Văn phòng - HCTP > A. Quản lý đơn, Công văn, Hồ sơ >  2. Nhận đơn (từ tòa án khác chuyển đến)"
                    //             * Sẽ nhìn thấy các đơn tòa khác chuyển đến
                    //             * Sẵn sàng thực hiện chức năng nhận đơn
                    //             */
                    //            UpdateDonChuyen(row, ToaAn_Chuyen, ToaAn_Nhan, DonID);
                    //        }
                    //    }
                    //}
                    #endregion
                    LoadCombobox();
                    Load_Data();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

                    Cls_Comon.SetButton(cmdNhandon, oPer.CAPNHAT);
                }
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        private void LoadCombobox()
        {
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ddlToachuyen.DataSource = dt.DM_TOAAN.Where(x => x.LOAITOA == "CAPCAO" || x.LOAITOA == "TOICAO").Where(y => y.ID != ToaAnID).ToList(); ;
            ddlToachuyen.DataTextField = "MA_TEN";
            ddlToachuyen.DataValueField = "ID";
            ddlToachuyen.DataBind();
            ddlToachuyen.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));

            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả --- ", "0"));
        }
        private DataTable getDS()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaChuyenID = Convert.ToDecimal(ddlToachuyen.SelectedValue), vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue),
                HinhThucDon = Convert.ToDecimal(ddlHinhthucdon.SelectedValue);
            string SoCMND = txtSoCMND.Text.Trim(), SoHieuDon = txtSohieudon.Text.Trim()
            , SoCongVan = txtCV_So.Text.Trim(), vNguoigui = txtNguoigui.Text;
            DateTime? TuNgay = txtNgaychuyenTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaychuyenTu.Text, cul, DateTimeStyles.NoCurrentDateDefault),
                DenNgay = txtNgaychuyenDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaychuyenDen.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            decimal vTrangthai = Convert.ToDecimal(rbtTrangthai.SelectedValue);
            DataTable oDT = oBL.GDTTT_NHANDON_SEARCH(ToaAnID, ToaChuyenID, vLoaiAn, vNguoigui,
                   SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, SoCongVan, vTrangthai);
            
            return oDT;
        }
        private void Load_Data()
        {
            DataTable oDT = getDS();
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(oDT.Rows.Count, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> đơn trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }

            dgList.DataSource = oDT;
            dgList.DataBind();

        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void cmdNhandon_Click(object sender, EventArgs e)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            bool flag = false;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                decimal ID = Convert.ToDecimal(chk.ToolTip);
                if (chk.Checked)
                {
                    flag = true;
                    GDTTT_DON_CHUYEN oT = dt.GDTTT_DON_CHUYEN.Where(x => x.ID == ID).FirstOrDefault();
                    oT.TRANGTHAI = 2;//đã nhận
                    oT.GHICHU = txtGhichu.Text;
                    oT.NGAYNHAN = DateTime.Now;
                    oT.NGUOINHAN = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                    String[] arr = oT.ARRDONTRUNG.Split(',');
                    decimal v_DONID = 0;
                    decimal v_DONID_GOC = 0;
                    for (int i = 0; i < arr.Length; i++)
                    {
                        v_DONID =Convert.ToDecimal(arr[i]);
                        GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == v_DONID).First();
                        if (oDon != null)
                        {
                            GDTTT_DON oDonnew = new GDTTT_DON();
                            oDonnew = oDon;
                            dt.GDTTT_DON.Add(oDonnew);
                            dt.SaveChanges();
                            if (Convert.ToDecimal(arr[i] + "") == oT.DONID)
                            {
                                oDonnew.DONTRUNGID = null;
                                v_DONID_GOC = oDonnew.ID;
                            }
                            else
                            {
                                oDonnew.DONTRUNGID = v_DONID_GOC;
                            }
                            oDonnew.TOAANID = ToaAnID;
                            oDonnew.VUVIECID = null;
                            oDonnew.CV_ISTRONGNGANH = null;
                            oDonnew.CV_TOAANID = null;
                            oDonnew.CV_TENDONVI = null;
                            oDonnew.CV_SO = null;
                            oDonnew.CV_NGAY = null;
                            oDonnew.CV_TINHID = null;
                            oDonnew.CV_HUYENID = null;
                            oDonnew.CV_DIACHI = null;
                            oDonnew.CV_NGUOIKY = null;
                            oDonnew.CV_CHUCVU = null;
                            oDonnew.TRALOIDON = null;
                            oDonnew.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            oDonnew.NGAYTAO = DateTime.Now;
                            oDonnew.NGUOISUA = null;
                            oDonnew.NGAYSUA = null;
                            oDonnew.CV_NHACLAIID = null;
                            oDonnew.CV_NHACLAITEXT = null;
                            oDonnew.CV_TRALOI_SO = null;
                            oDonnew.CV_TRALOI_NGAY = null;
                            oDonnew.CV_TRALOI_NOIDUNG = null;
                            oDonnew.CD_LOAI = 0;
                            oDonnew.CD_TA_DONVIID = null;
                            oDonnew.CD_TA_TRANGTHAI = null;
                            oDonnew.CD_TA_LYDO_ISBAQD = null;
                            oDonnew.CD_TA_LYDO_ISXACNHAN = null;
                            oDonnew.CD_TA_LYDO_ISKHAC = null;
                            oDonnew.CD_TK_DONVIID = null;//don vi chuyen
                            oDonnew.CD_TK_NOIGUI = null;
                            oDonnew.CD_NTA_TENDONVI = null;
                            oDonnew.CD_TRALAI_LYDOID = null;
                            oDonnew.CD_TRALAI_YEUCAU = null;
                            oDonnew.CD_TRALAI_SOPHIEU = null;
                            oDonnew.CD_TRALAI_NGAYTRA = null;
                            oDonnew.CD_TRANGTHAI = 0;
                            oDonnew.CD_NGAYXULY = null;
                            oDonnew.TL_NGAY = null;
                            oDonnew.TL_NGUOI = null;
                            oDonnew.THAMPHANID = null;
                            oDonnew.CD_NGUOIKY = null;
                            oDonnew.CD_SOCV = null;
                            oDonnew.CD_NGAYCV = null;
                            oDonnew.TL_SO = null;
                            oDonnew.CD_TRALAI_LYDOKHAC = null;
                            oDonnew.CD_TA_LYDO_KHAC = null;
                            oDonnew.CV_YEUCAUTHONGBAO = null;
                            oDonnew.CV_TRALOI_TOAANID = null;
                            oDonnew.TL_SOTT = null;
                            oDonnew.CV_ISTRAIGIAM = null;
                            oDonnew.CHIDAO_COKHONG = null;
                            oDonnew.CHIDAO_THOIHAN = null;
                            oDonnew.CONLAI_SOLUONG = null;
                            oDonnew.CONLAI_ARRDONID = null;
                            oDonnew.GQ_THAMTRAVIENID = null;
                            oDonnew.GQ_NGAYPHANCONG = null;
                            oDonnew.GQ_NGUOIPHANCONGID = null;
                            oDonnew.KN_TRALOIDON = null;
                            oDonnew.CHIDAO_LANHDAOID = null;
                            oDonnew.CHIDAO_NOIDUNG = null;
                            oDonnew.TB1_SO = null;
                            oDonnew.TB1_NGAY = null;
                            oDonnew.TB2_SO = null;
                            oDonnew.TB2_NGAY = null;
                            oDonnew.TBTLD_SO = null;
                            oDonnew.TBTLD_NGAY = null;
                            oDonnew.CHIDAO_KINHTRINH = null;
                            oDonnew.CV_TRAIGIAMHIENTAI = null;
                            oDonnew.CD_SOTOTRINH = null;
                            oDonnew.CD_NGAYTOTRINH = null;
                            ///-------------
                            dt.SaveChanges();
                        }
                    }
                    //---------------------------
                    ////Thay đổi trong thông tin đơn
                    // Cập nhật lại trạng thái đã nhận
                    // TRANG_THAI_CHUYEN(0: chưa nhận; 1: Đã nhận; 2: Trả lại) 
                    //string sql = "update CHUYEN_NHAN_DON_GDT set TRANG_THAI_CHUYEN=1 where GUID='" + oDon.ID_DON_QLACC + "'";
                    //Cls_Comon.ExcuteProc_With_Connection(CONNECTION_TO_DB_TRUNGGIAN, sql);
                }
            }
            if (flag == false)
            {
                lbtthongbao.Text = "Chưa chọn đơn !";
                return;
            }
            else
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                Load_Data();
            }
        }
        protected void cmdTralai_Click(object sender, EventArgs e)
        {
            if (txtGhichu.Text == "")
            {
                lbtthongbao.Text = "Chưa nhập lý do trả lại đơn !";
                return;
            }
            bool flag = false;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                decimal ID = Convert.ToDecimal(chk.ToolTip);
                if (chk.Checked)
                {
                    flag = true;
                    GDTTT_DON_CHUYEN oT = dt.GDTTT_DON_CHUYEN.Where(x => x.ID == ID).FirstOrDefault();
                    //oT.TRANGTHAI = 2;
                    //oT.GHICHU = txtGhichu.Text;
                    //oT.NGAYNHAN = DateTime.Now;
                    //oT.NGUOINHAN = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    //dt.SaveChanges();

                    //Thay đổi trong thông tin đơn
                    GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == oT.DONID).FirstOrDefault();
                    oDon.CD_TRANGTHAI = 3;
                    dt.SaveChanges();

                    //Update danh sách lịch sử chuyển đơn và xoa bang GDTTT_DON_CHUYEN;
                    update_lichsu_chuyendon(oDon.ID, Convert.ToDecimal(oDon.CD_TK_DONVIID), txtGhichu.Text);

                    //Xóa thông tin đẫ chuyển từ bảng đơn chuyển
                    //objLS.DONVINHANID = oDon.CD_TK_DONVIID;  --Don vi nhan
                    //xoa_thongtinchuyen(ID, Convert.ToDecimal(oDon.CD_TK_DONVIID));
                }
            }
            if (flag == false)
            {
                lbtthongbao.Text = "Chưa chọn đơn trả lại !";
                return;
            }
            else
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                Load_Data();
            }
        }
        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion
        //---------------CHỨC NĂNG-------------------
        protected void chkChonAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
            }
        }
        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chk = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chk.ToolTip);

        }
        protected void rbtTrangthai_SelectedIndexChanged(object sender, EventArgs e)
        {
            //if (rbtTrangthai.SelectedValue == "1")
            //{
            //    lblGhichu.Visible = true;
            //    txtGhichu.Visible = true;
            //    Cls_Comon.SetButton(cmdNhandon, true);
            //    Cls_Comon.SetButton(cmdTralai, true);
            //}
            //else
            //{
                lblGhichu.Visible = false;
                txtGhichu.Visible = false;
                Cls_Comon.SetButton(cmdNhandon, false);
                Cls_Comon.SetButton(cmdTralai, false);
            //}
        }
        private decimal UpdateThongTinDon(THONG_TIN_DON TTDon, decimal ToaAn_Chuyen)
        {
            bool IsNew = false;
            decimal DonID = 0;
            string TenNguoiSuDung = "";
            QT_NGUOISUDUNG NSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == UserID).FirstOrDefault();
            if (NSD != null)
            {
                TenNguoiSuDung = NSD.HOTEN;
            }
            GDTTT_DON Don = dt.GDTTT_DON.Where(x => x.TOAANID == ToaAn_Chuyen && x.ID_DON_QLACC == TTDon.GUID).FirstOrDefault();
            if (Don == null)
            {
                IsNew = true;
                Don = new GDTTT_DON
                {
                    NGAYTAO = DateTime.Now,
                    NGUOITAO = TenNguoiSuDung
                };
            }
            else
            {
                Don.NGAYSUA = DateTime.Now;
                Don.NGUOISUA = TenNguoiSuDung;
            }
            Don.LOAIDON = TTDon.HINHTHUCDON;
            Don.NGUOIGUI_HOTEN = TTDon.NGUOIGUI;
            Don.NGUOIGUI_TINHID = TTDon.TINH + "" == "" ? 0 : Convert.ToDecimal(TTDon.TINH);
            Don.NGUOIGUI_HUYENID = TTDon.HUYEN + "" == "" ? 0 : Convert.ToDecimal(TTDon.HUYEN);
            Don.NGUOIGUI_DIACHI = TTDon.CHITIET;
            Don.NGUOIGUI_GIOITINH = TTDon.GIOITINH;
            DateTime NgayNhanDon = DateTime.MinValue,
                     NgayGhiTrenDon = DateTime.MinValue;
            if (DateTime.TryParseExact(TTDon.NGAYNHANDON, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayNhanDon))
            {
                Don.NGAYNHANDON = NgayNhanDon;
            }
            if (DateTime.TryParseExact(TTDon.NGAYGHITRENDON, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayGhiTrenDon))
            {
                Don.NGAYGHITRENDON = NgayGhiTrenDon;
            }
            switch (TTDon.TUCACHTOTUNG)
            {
                case "NGUYENDON":
                    Don.NGUOIGUI_TUCACHTOTUNG = 1;// Bị can/Đương sự
                    break;
                case "BIDON":
                    Don.NGUOIGUI_TUCACHTOTUNG = 1;// Bị can/Đương sự
                    break;
                case "BICAO":
                    Don.NGUOIGUI_TUCACHTOTUNG = 1;// Bị can/Đương sự
                    break;
                case "BIHAI":
                    Don.NGUOIGUI_TUCACHTOTUNG = 2;//Người tham gia tố tụng
                    break;
                case "KHAC":
                    Don.NGUOIGUI_TUCACHTOTUNG = 4;// Khác
                    break;
                default:
                    Don.NGUOIGUI_TUCACHTOTUNG = 3;// Người không liên quan đến vụ án
                    break;
            }
            Don.NOIDUNGDON = TTDon.NOIDUNGDON;
            Don.GHICHU = TTDon.GHICHU;
            Don.TRALOIDON = TTDon.KETQUAGIAIQUYET;
            Don.CV_TRALOI_NOIDUNG = TTDon.NOIDUNGGIAIQUYET;
            Don.CHIDAO_LANHDAOID = TTDon.CANBOCHIDAO + "" == "" ? 0 : Convert.ToDecimal(TTDon.CANBOCHIDAO);
            Don.CHIDAO_NOIDUNG = TTDon.YKIENCHIDAO;
            if (Don.CHIDAO_LANHDAOID == 0)
            {
                Don.CHIDAO_COKHONG = 0;
            }
            else
            {
                Don.CHIDAO_COKHONG = 1;
            }
            if (TTDon.ISDONTRUNG == 1) // Nếu đơn là đơn trùng
            {
                byte[] MaDon = Encoding.ASCII.GetBytes(TTDon.MADONTRUNG);
                GDTTT_DON DonGoc = dt.GDTTT_DON.Where(x => x.ID_DON_QLACC == MaDon).FirstOrDefault();
                if (DonGoc != null)
                {
                    Don.DONTRUNGID = DonGoc.ID;
                }
            }
            Don.CV_SO = TTDon.CV_SO;
            DateTime NgayCongVan = DateTime.MinValue;
            if (DateTime.TryParseExact(TTDon.CV_NGAY, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayCongVan))
            {
                Don.CV_NGAY = NgayCongVan;
            }
            Don.CV_ISTRONGNGANH = TTDon.CV_ISTRONGNGANH;
            DM_TOAAN ToaAnGuiCV = dt.DM_TOAAN.Where(x => x.MA == TTDon.CV_DONVI || x.TEN.Trim().ToLower() == TTDon.CV_DONVI.Trim().ToLower()).FirstOrDefault();
            if (ToaAnGuiCV != null)
            {
                Don.CV_TOAANID = ToaAnGuiCV.ID;
            }
            Don.CV_NGUOIKY = TTDon.CV_NGUOIKY;
            Don.CV_CHUCVU = TTDon.CV_CHUCVU;
            Don.CV_TINHID = TTDon.CV_TINH + "" == "" ? 0 : Convert.ToDecimal(TTDon.CV_TINH);
            Don.CV_HUYENID = TTDon.CV_HUYEN + "" == "" ? 0 : Convert.ToDecimal(TTDon.CV_HUYEN);
            DM_DATAGROUP G_LoaiCongVan = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.LOAICVGDTTT).FirstOrDefault();
            if (G_LoaiCongVan != null)
            {
                DM_DATAITEM LoaiCongVan = dt.DM_DATAITEM.Where(x => x.GROUPID == G_LoaiCongVan.ID && x.MA == TTDon.CV_LOAI).FirstOrDefault();
                if (LoaiCongVan != null)
                {
                    Don.LOAICONGVAN = LoaiCongVan.ID;
                }
            }
            Don.CV_ISTRAIGIAM = TTDon.CV_ISTRAIGIAM;
            Don.CV_YEUCAUTHONGBAO = TTDon.YEUCAUTHONGBAO;
            if (TTDon.GIAIQUYETDON == 3) // Xếp đơn
            {
                Don.CD_LOAI = 4;// Xếp dơn
            }
            else if (TTDon.GIAIQUYETDON == 1) // Trả lời đơn
            {
                Don.CD_LOAI = 3; // Trả lại đơn
            }
            else if (TTDon.GIAIQUYETDON == 4) // Xử lý khác
            {
                Don.CD_LOAI = 2; // Ngoài tòa án
            }
            else if (TTDon.GIAIQUYETDON == 2) // Kháng nghị
            {
                Don.CD_LOAI = 1; // Tòa khác
            }
            else
            {
                Don.CD_LOAI = 0;// Nội bộ
            }
            Don.BAQD_LOAIQDBA = TTDon.BAQD_LOAI;
            Don.BAQD_SO = TTDon.BAQD_SO;
            DateTime NgayBAQD = DateTime.MinValue;
            if (DateTime.TryParseExact(TTDon.BAQD_NGAY, "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayBAQD))
            {
                Don.BAQD_NGAYBA = NgayBAQD;
            }
            Don.BAQD_TOAANID = TTDon.BAQD_TOAAN + "" == "" ? 0 : Convert.ToDecimal(TTDon.BAQD_TOAAN);
            if (IsNew)
            {
                dt.GDTTT_DON.Add(Don);
            }
            dt.SaveChanges();
            DonID = Don.ID;
            return DonID;
        }
        private void UpdateDonChuyen(DataRow row, decimal ToaChuyenID, decimal ToaNhanID, decimal DonID)
        {
            bool IsNew = false;
            GDTTT_DON_CHUYEN Don_Chuyen = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == DonID && x.DONVICHUYENID == ToaChuyenID && x.DONVINHANID == ToaNhanID).FirstOrDefault();
            if (Don_Chuyen == null)
            {
                IsNew = true;
                Don_Chuyen = new GDTTT_DON_CHUYEN();
            }
            Don_Chuyen.DONID = DonID;
            Don_Chuyen.DONVICHUYENID = ToaChuyenID;
            Don_Chuyen.DONVINHANID = ToaNhanID;
            Don_Chuyen.TRANGTHAI = row["TRANG_THAI_CHUYEN"] + "" == "" ? 0 : Convert.ToDecimal(row["TRANG_THAI_CHUYEN"]);
            Don_Chuyen.NGUOICHUYEN = row["NGUOI_CHUYEN"] + "";
            Don_Chuyen.NGUOINHAN = row["NGUOI_NHAN"] + "";
            DateTime NgayChuyen = DateTime.MinValue,
                     NgayNhan = DateTime.MinValue;
            if (DateTime.TryParseExact(row["NGAY_CHUYEN"] + "", "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayChuyen))
            {
                Don_Chuyen.NGAYCHUYEN = NgayChuyen;
            }
            if (DateTime.TryParseExact(row["NGAY_NHAN"] + "", "dd-MM-yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayNhan))
            {
                Don_Chuyen.NGAYNHAN = NgayNhan;
            }
            if (IsNew)
            {
                dt.GDTTT_DON_CHUYEN.Add(Don_Chuyen);
            }
            dt.SaveChanges();
        }
        private void Update_DongKhieuNai(decimal DonID, List<DONGKHIEUNAI> ListDongKhieuNai)
        {
            if (ListDongKhieuNai.Count > 0)
            {
                bool IsNew = false;
                foreach (DONGKHIEUNAI item in ListDongKhieuNai)
                {
                    GDTTT_DON_NGUOIKN NguoiKN = dt.GDTTT_DON_NGUOIKN.Where(x => x.DONID == DonID && x.HOTEN.ToLower() == item.TEN.ToLower()).FirstOrDefault();
                    if (NguoiKN == null)
                    {
                        IsNew = true;
                        NguoiKN = new GDTTT_DON_NGUOIKN();
                    }
                    NguoiKN.DONID = DonID;
                    NguoiKN.HOTEN = item.TEN;
                    NguoiKN.DIACHI = item.DIACHI;
                    if (IsNew)
                    {
                        dt.GDTTT_DON_NGUOIKN.Add(NguoiKN);
                    }
                    dt.SaveChanges();
                }
            }
        }

        //void xoa_thongtinchuyen(Decimal CurrDonID, Decimal CurrDonViNhanID)
        //{
        //    try
        //    {
        //        List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == CurrDonID
        //                                                                    && x.DONVINHANID == CurrDonViNhanID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
        //        if (lstC.Count > 0)
        //        {
        //            GDTTT_DON_CHUYEN oC = lstC[0];
        //            //Xóa thông tin đẫ chuyển từ bảng đơn chuyển
        //            dt.GDTTT_DON_CHUYEN.Remove(oC);
        //            dt.SaveChanges();

        //        }
        //    }
        //    catch (Exception ex) { }
        //}

        void update_lichsu_chuyendon(Decimal CurrDonID, Decimal CurrDonViNhanID, String LyDoTraDon)
        {
            try
            {
                List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == CurrDonID
                                                                            && x.DONVINHANID == CurrDonViNhanID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
                if (lstC.Count > 0)
                {
                    GDTTT_DON_CHUYEN oC = lstC[0];
                    //lưu ngày nhận là ngày hiện tại CurrNgayNhan
                    //oC.NGAYNHAN = DateTime.Now;
                    //oC.TRANGTHAI = 3;
                    //oC.NGUOINHAN = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    //oC.GHICHU = txtBC_Ghichu.Text;
                    //dt.SaveChanges();
                    //lưu thông tin đơn trả lại vào bảng lịch xử
                    GDTTT_DON_CHUYEN_HISTORY oH = new GDTTT_DON_CHUYEN_HISTORY();
                    oH.DONID = oC.DONID;
                    oH.DONVICHUYENID = oC.DONVICHUYENID;
                    oH.DONVINHANID = oC.DONVINHANID;
                    oH.NGAYCHUYEN = oC.NGAYCHUYEN;
                    oH.NGAYNHAN = oC.NGAYNHAN;
                    oH.TRANGTHAI = 3;
                    oH.NGUOICHUYEN = oC.NGUOICHUYEN;
                    oH.NGUOINHAN = oC.NGUOINHAN;
                    oH.PHONGBANCHUYENID = oC.PHONGBANCHUYENID;
                    oH.PHONGBANNHANID = oC.PHONGBANNHANID;
                    oH.SOCV = oC.SOCV;
                    oH.NGAYCV = oC.NGAYCV;
                    oH.NGUOIKY = oC.NGUOIKY;
                    oH.LOAICHUYEN = oC.LOAICHUYEN;
                    oH.GHICHU = LyDoTraDon;
                    oH.SOLUONGDON = oC.SOLUONGDON;
                    oH.ARRDONTRUNG = oC.ARRDONTRUNG;
                    oH.NGAYTRA = DateTime.Now;
                    oH.NGUOITRA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    dt.GDTTT_DON_CHUYEN_HISTORY.Add(oH);
                    dt.SaveChanges();
                    //Xóa thông tin đẫ chuyển từ bảng đơn chuyển
                    dt.GDTTT_DON_CHUYEN.Remove(oC);
                    dt.SaveChanges();

                }
            }
            catch (Exception ex) { }
        }
    }
}