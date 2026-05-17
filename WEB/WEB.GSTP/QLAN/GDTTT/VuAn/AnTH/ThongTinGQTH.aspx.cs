using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class ThongTinGQTH : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrentUserID = 0;
        public Decimal VuAnID = 0;
        Decimal hsid = 0;
        List<GDTTT_DON> lstDon = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            hsid = String.IsNullOrEmpty(Request["hsid"] + "") ? 0 : Convert.ToDecimal(Request["hsid"] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    if (VuAnID > 0)
                    {
                        lstDon = dt.GDTTT_DON.Where(x => x.VUVIECID == VuAnID
                                                      && x.CD_TRANGTHAI == 2
                                                      && x.ISTHULY == 1).OrderBy(x => x.TL_NGAY).ToList();

                        //-----------------------------
                        GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                        LoadThongTinVuAn(obj);

                        //------------------------------
                        //try
                        //{
                        //    //txtVuAn_SoThuLy.Text = (String.IsNullOrEmpty(obj.SOTHULYDON + "") ? "" : ("Số <b>" + obj.SOTHULYDON + "</b>"))
                        //    //                        + ((String.IsNullOrEmpty(obj.NGAYTHULYDON + "") || (obj.NGAYTHULYDON == DateTime.MinValue)) ? "" : (" ngày <b>" + ((DateTime)obj.NGAYTHULYDON).ToString("dd/MM/yyyy", cul) + "</b>"));
                        //    Load_ThongTinThuLy(VuAnID, lstDon);
                        //}
                        //catch (Exception ex) { }

                        //---------------------------

                        try { LoadThongtinQGTH(); } catch (Exception ex) { }

                        //---------------------
                      

                        //-----------------------------
                        try { Load_TTV_LanhDao(obj); } catch (Exception ex) { }

                        //--------------------
                        try { Load_QLHoSo(); } catch (Exception ex) { }

                        //----------------------
                        try { LoadToTrinh(); } catch (Exception ex) { }

                        ////----------------------
                        //try
                        //{
                        //    //LoadDsNguoiKhieuNai_KQGQ(obj, lstDon);
                        //    LoadDsNguoiKhieuNai(lstDon);
                        //}
                        //catch (Exception ex) { }
                        //try
                        //{
                        //    LoadKQGQDon_AHS(obj);
                        //}
                        //catch (Exception ex) { }


                        ////---------------------------
                        //try { Load_XetXuGDTTT(obj); } catch (Exception ex) { }

                    }
                }
            }
        }
        void Load_ThongTinThuLy(Decimal VuAnID, List<GDTTT_DON> lstDon)
        {
            String Str = "";
            if (lstDon == null)
            {
                lstDon = dt.GDTTT_DON.Where(x => x.VUVIECID == VuAnID
                                                       && x.CD_TRANGTHAI == 2
                                                       && x.ISTHULY == 1).OrderBy(x => x.TL_NGAY).ToList();
            }
            if (lstDon != null && lstDon.Count > 0)
            {
                int count_item = 1;
                
                foreach (GDTTT_DON item in lstDon)
                {
                   
                    Str += "<div class='row_info'>";
                    Str += "Thụ lý ";
                    Str += "<span style='margin-left: 5px;'>";
                    Str += (String.IsNullOrEmpty(item.TL_SO + "") ? "" : "số " + item.TL_SO);
                    Str += (String.IsNullOrEmpty(item.TL_NGAY + "") ? "" : (" ngày " + ((DateTime)item.TL_NGAY).ToString("dd/MM/yyyy", cul) + ""));
                    Str += "</span>";
                    Str += String.IsNullOrEmpty(item.NGUOIGUI_HOTEN + "") ? "" : " của " + item.NGUOIGUI_HOTEN;
                    Str += "</div>";
                    count_item++;
                }
                txtVuAn_SoThuLy.Text = Str;
            }
            
        }
        void LoadThongTinVuAn(GDTTT_VUAN obj)
        {
            string temp = "";
            string temp_str = "";
            decimal temp_id = 0;
            if (obj != null)
            {
                temp_str = "";
                temp_id = String.IsNullOrEmpty(obj.LOAIAN + "") ? 0 : (decimal)obj.LOAIAN;
                
                lttTenVuAn.Text = obj.TENVUAN;// + (String.IsNullOrEmpty(obj.NGUYENDON+"")? "": (string.IsNullOrEmpty(obj.)));

                //------------------------
                #region BA/QD  phuc tham, ST
                try
                {
                    temp = (String.IsNullOrEmpty(obj.SOANPHUCTHAM + "")) ? "" : ("Số <b>" + obj.SOANPHUCTHAM + "</b>");
                    temp += (String.IsNullOrEmpty(obj.NGAYXUPHUCTHAM + "") || (obj.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : "  ngày <b>" + ((DateTime)obj.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul) + "</b>";
                    lttBanAnPT.Text = temp;
                }
                catch (Exception ex) { }

                DM_TOAAN objTA = null;
                string ten_toa_an = "", soansotham = "";
                temp_id = String.IsNullOrEmpty(obj.TOAPHUCTHAMID + "") ? 0 : (decimal)obj.TOAPHUCTHAMID;
                if (temp_id > 0)
                {
                    objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAPHUCTHAMID).Single();
                    lttToaXuPT.Text = objTA.MA_TEN;
                    //------------------
                    temp = temp_str = "";
                    if (objTA.MA == "CAPCAO")
                    {
                        temp_id = (string.IsNullOrEmpty(obj.TOAANSOTHAM + "")) ? 0 : (decimal)obj.TOAANSOTHAM;
                        if (temp_id > 0)
                        {
                            objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAANSOTHAM).Single();
                            ten_toa_an = " tại " + objTA.MA_TEN;
                        }
                        //------------------------
                        temp_str = (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ("  ngày <b>" + ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul) + "</b>");
                        soansotham = (String.IsNullOrEmpty(obj.SOANSOTHAM + "") || obj.SOANSOTHAM == " ") ? "" : ("Số <b>" + obj.SOANSOTHAM + "</b>");
                        lttBanAnST.Text = soansotham + temp_str + ten_toa_an;
                        if (String.IsNullOrEmpty(lttBanAnST.Text.Trim()))
                            pnAnST.Visible = false;
                        else pnAnST.Visible = true;
                    }
                    else pnAnST.Visible = false;
                }

                #endregion
                //------------------------
                lttGhiChu.Text = obj.GHICHU + "";
            }
        }
        void LoadDsNguoiKhieuNai(List<GDTTT_DON> lstKN)
        {
           decimal vID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            if (lstKN == null)
            {
                lstKN = dt.GDTTT_DON.Where(x => x.VUVIECID == vID
                                             && x.CD_TRANGTHAI == 2
                                             && x.ISTHULY == 1).OrderBy(x => x.TL_NGAY).ToList();
            }
            String TenNguoiKN = "", temp = "";
            if (lstKN != null && lstKN.Count > 0)
            {
                foreach (GDTTT_DON oDon in lstKN)
                {
                    temp = oDon.NGUOIGUI_HOTEN;
                    if ((!String.IsNullOrEmpty(TenNguoiKN + "")) && (!String.IsNullOrEmpty(temp + "")))
                        TenNguoiKN += ", ";
                    TenNguoiKN += temp;
                }
                //lttVuAn_NguoiKhieuNai.Text = TenNguoiKN;
            }
            
            //else
            //{
            //    pnGQD.Visible = true;
            //    Load_GQDon(oVA);
            //}
        }
     
       
        void Load_TTV_LanhDao(GDTTT_VUAN obj)
        {
            String temp_str = "";
            decimal temp_id = 0;
            #region ---------thong tin TTV/LD----------------

            #region Thông tin TTV/lanh dao
            DM_CANBO objCB = null;
            //-------------------------------
            temp_id = (string.IsNullOrEmpty(obj.THAMPHANID + "")) ? 0 : (decimal)obj.THAMPHANID;
            if (temp_id > 0)
            {
                objCB = dt.DM_CANBO.Where(x => x.ID == temp_id).Single();
                lttTP.Text = objCB.HOTEN;
            }
            //----------------------------
            temp_id = (String.IsNullOrEmpty(obj.THAMTRAVIENID + "")) ? 0 : Convert.ToDecimal(obj.THAMTRAVIENID);
            if (temp_id > 0)
            {
                objCB = dt.DM_CANBO.Where(x => x.ID == temp_id).Single();
                lttTTV.Text = objCB.HOTEN;
            }
            //-----------------
            temp_id = (String.IsNullOrEmpty(obj.LANHDAOVUID + "")) ? 0 : Convert.ToDecimal(obj.LANHDAOVUID);
            if (temp_id > 0)
            {
                objCB = dt.DM_CANBO.Where(x => x.ID == temp_id).Single();
                lttLD.Text = objCB.HOTEN;
            }
            #endregion

            //-----------Ngay TTV Nhan THS----------------------
            temp_str = (String.IsNullOrEmpty(obj.NGAYTTVNHAN_THS + "") || (obj.NGAYTTVNHAN_THS == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTTVNHAN_THS).ToString("dd/MM/yyyy", cul);
            lttNgayTTVNhanTHS.Text = temp_str;

            //-----------Ngay TTV Nhan THS----------------------
            temp_str = "";// (String.IsNullOrEmpty(obj.NGAYNHANHOSO + "") || (obj.NGAYNHANHOSO == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYNHANHOSO).ToString("dd/MM/yyyy", cul);            
            if (String.IsNullOrEmpty(temp_str))
            {
                int page_size = 30000;
                int pageindex = 1;
                int loaiphieu = 3;
                GDTTT_QUANLYHS_BL objBL = new GDTTT_QUANLYHS_BL();
                DataTable tblPhieuNhan = objBL.GetByVuAn_LoaiPhieu(VuAnID, loaiphieu, pageindex, page_size);
                if (tblPhieuNhan != null && tblPhieuNhan.Rows.Count > 0)
                {
                    DataRow rowPN = tblPhieuNhan.Rows[0];
                    temp_str = (String.IsNullOrEmpty(rowPN["SoPhieu"] + "") ? "" : ("Số " + rowPN["SoPhieu"].ToString()))
                                + (String.IsNullOrEmpty(rowPN["NGAYTAo"] + "") ? "" : (" ngày " + rowPN["NGAYTAo"].ToString()));
                }
            }
            lttNgayTTVNhanHS.Text = temp_str;
            // pnTTVNhanHS.Visible = !String.IsNullOrEmpty(temp_str);

            #endregion
        }

        void LoadThongtinQGTH()
        {
            Decimal hs_ID = Convert.ToDecimal(Request["hsid"] + "");
            GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
            DataTable tbl = null;
            tbl = oBL.HOSO_TUHINH_SEARCH(Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "", hs_ID, 0,
                0, null, null, 0, null, null, null, 1, 20);
            decimal vuanid = Convert.ToDecimal(tbl.Rows[0]["VUAN_ID"]);
            lttBiAn.Text = Convert.ToString(tbl.Rows[0]["TENDUONGSU"]) + " - " + Convert.ToString(tbl.Rows[0]["HS_TENTOIDANH"]);
            
                
            if (tbl.Rows[0]["ngaynhandon_vu"] != null)
            {
                lblNgaynhandon.Text = Convert.ToString(tbl.Rows[0]["ngaynhandon_vu"]) + "; ";
            }

            if (tbl.Rows[0]["ngaynhandon_hctp"] != null)
            {
                lblNgaynhandon_hctp.Text =Convert.ToString(tbl.Rows[0]["ngaynhandon_hctp"]);
            }
            
           
            if (tbl.Rows[0]["listDonVu"] != null)
            {
                lblNguoguidon_vu.Text = Convert.ToString(tbl.Rows[0]["listDonVu"]) + "; " ;
            }
            if (tbl.Rows[0]["LisThuLyDon"] != null)
            {
                txtVuAn_SoThuLy.Text = Convert.ToString(tbl.Rows[0]["LisThuLyDon"]);
            }

            if (tbl.Rows[0]["SOQD_CA"] != null)
            {
                Decimal LoaiQDCA = Convert.ToDecimal(tbl.Rows[0]["KETLUAN_CA"]);
                if (LoaiQDCA == 1)
                    lttLoaiKQCA.Text = "Quyết định không kháng nghị " +
                                        " số: " + Convert.ToString(tbl.Rows[0]["SOQD_CA"]) + 
                                        " - Ngày:" + Convert.ToDateTime(tbl.Rows[0]["NGAYQD_CA"]).ToString("dd/MM/yyyy");
                else if (LoaiQDCA == 2)
                    lttLoaiKQCA.Text = "Quyết định kháng nghị " +
                                        "số: " + Convert.ToString(tbl.Rows[0]["SOQD_CA"]) +
                                        " - Ngày:" + Convert.ToDateTime(tbl.Rows[0]["NGAYQD_CA"]).ToString("dd/MM/yyyy");
                //Decimal vCAPTRINH = Convert.ToDecimal(tbl.Rows[0]["CAPTRINH"]);
                //if (vCAPTRINH == 18)
                //    lttTTCA.Text = "Tờ trình Chủ tịch nước " +
                //                    " Số: " + Convert.ToString(tbl.Rows[0]["SOTT"]) +
                //                    " - Ngày:" + Convert.ToString(tbl.Rows[0]["NGAYTT"]) +
                //                    " - Nội dung trình: " + Convert.ToString(tbl.Rows[0]["LOAIYK"]);

            }

           
            if (tbl.Rows[0]["SOQD_VKS"] != null)
            {
                Decimal LoaiQDVKS = Convert.ToDecimal(tbl.Rows[0]["KETLUAN_VKS"]);
                if (LoaiQDVKS == 1)
                    lttKLVKS.Text = "Quyết định không kháng nghị " +
                                    " số: " + Convert.ToString(tbl.Rows[0]["SOQD_VKS"]) +
                                    " - Ngày:" + Convert.ToDateTime(tbl.Rows[0]["NGAYQD_VKS"]).ToString("dd/MM/yyyy") ;
                else if (LoaiQDVKS == 2)
                    lttKLVKS.Text = "Quyết định kháng nghị " +
                                    "số: " + Convert.ToString(tbl.Rows[0]["SOQD_VKS"]) + 
                                    " - Ngày:" + Convert.ToDateTime(tbl.Rows[0]["NGAYQD_VKS"]).ToString("dd/MM/yyyy") ;
                lttKLVKS.Text += "<br>Tờ trình Số: " + Convert.ToString(tbl.Rows[0]["SOTT_VKS"]) +
                                    " - Ngày:" + Convert.ToDateTime(tbl.Rows[0]["NGAYTT_VKS"]).ToString("dd/MM/yyyy");
                decimal NoidungTTVKS = Convert.ToDecimal(tbl.Rows[0]["NOIDUNGTT_VKS"]);
                if (NoidungTTVKS==1)
                    lttKLVKS.Text += " - Nội dung trình: Bác đơn";
                else if (NoidungTTVKS == 2)
                    lttKLVKS.Text += " - Nội dung trình: Ân giảm";
            }

            if (tbl.Rows[0]["CTN_SOQĐ"] != null)
            {
                Decimal LoaiQDCTN = Convert.ToDecimal(tbl.Rows[0]["CTN_LOAIQD"]);
                if (LoaiQDCTN == 1)
                    lttVPCTN.Text = "Quyết định Bác đơn" +
                                    " số: " + Convert.ToString(tbl.Rows[0]["CTN_SOQĐ"]) +
                                    " - Ngày: " + Convert.ToDateTime(tbl.Rows[0]["CTN_NGAYQD"]).ToString("dd/MM/yyyy") +
                                    " - Ngày trả: " + Convert.ToDateTime(tbl.Rows[0]["CTN_NGAYTRA"]).ToString("dd/MM/yyyy");
                else if (LoaiQDCTN == 2)
                    lttVPCTN.Text = "Quyết định Giảm án " +
                                    " số: " + Convert.ToString(tbl.Rows[0]["CTN_SOQĐ"]) +
                                    " - Ngày: " + Convert.ToDateTime(tbl.Rows[0]["CTN_NGAYQD"]).ToString("dd/MM/yyyy") +
                                    " - Ngày trả: " + Convert.ToDateTime(tbl.Rows[0]["CTN_NGAYTRA"]).ToString("dd/MM/yyyy");
            }

            
            if (tbl.Rows[0]["SOCVXM"] != null)
            {
                lttCVXM.Text = " CV Xác Minh số: " + Convert.ToString(tbl.Rows[0]["SOCVXM"]) +
                              " - Ngày: " + Convert.ToDateTime(tbl.Rows[0]["NGAYCVXM"]).ToString("dd/MM/yyyy");
                //if (tbl.Rows[0]["NOIDUNGXM"] != null)
                //    lttCVXM.Text += " - Nội dung: " + Convert.ToString(tbl.Rows[0]["NOIDUNGXM"]);
            }
            

            if (tbl.Rows[0]["NGAYKQXM"] != null)
            {
                Decimal KQXM = Convert.ToDecimal(tbl.Rows[0]["LOAIKETQUAXM"]);
                if (KQXM == 1)
                    lttKQXM.Text = "Kết quả xác minh: đúng thông tin Bị án" +
                                    " - ngày: " + Convert.ToDateTime(tbl.Rows[0]["NGAYKQXM"]).ToString("dd/MM/yyyy");
                else if (KQXM == 2)
                    lttKQXM.Text = "Kết quả xác minh: không đúng thông tin Bị án" +
                                    " - ngày: " + Convert.ToDateTime(tbl.Rows[0]["NGAYKQXM"]).ToString("dd/MM/yyyy");
                //if (tbl.Rows[0]["NOIDUNG_KQXM"] != null)
                //    lttKQXM.Text += " - Nội dung: " + Convert.ToString(tbl.Rows[0]["NOIDUNG_KQXM"]);
            }

           
            if (tbl.Rows[0]["THA_KETQUA"] != null)
            {
                if (Convert.ToDecimal(tbl.Rows[0]["THA_KETQUA"]) == 1)
                    lttKQTHA.Text = "Đã thi hành án";
                else if (Convert.ToDecimal(tbl.Rows[0]["THA_KETQUA"]) == 2)
                    lttKQTHA.Text = "Đã chết";

                lttKQTHA.Text += " - Ngày: " + Convert.ToDateTime(tbl.Rows[0]["THA_NGAY"]).ToString("dd/MM/yyyy") +
                                    " - Địa điểm THA: " + Convert.ToString(tbl.Rows[0]["THA_DIADIEM"]);
            }



            if (tbl.Rows[0]["LUUHS_TINHTRANGHS"] != null)
            {
                lttLuuHS.Text = "Thông tin hồ sơ:";
                if (Convert.ToDecimal(tbl.Rows[0]["LUUHS_TINHTRANGHS"]) == 1)
                    lttLuuHS.Text += "Đầy đủ bút lục - ";
                else if (Convert.ToDecimal(tbl.Rows[0]["LUUHS_TINHTRANGHS"]) == 2)
                    lttLuuHS.Text += "Thiếu bút lục - ";
                              
                lttLuuHS.Text += Convert.ToString(tbl.Rows[0]["cabochuyen"]) + " chuyển lưu hồ sơ ngày: " + Convert.ToDateTime(tbl.Rows[0]["LUUHS_NGAYCHUYEN"]).ToString("dd/MM/yyyy") +
                                    " - Đơn vị nhận: " + Convert.ToString(tbl.Rows[0]["LUUHS_DONVINHAN"]);
            }
            

        }
        void LoadBiCao(Decimal VuAnID)
        {
            string tucachtt = ENUM_DANSU_TUCACHTOTUNG.BIDON;
            string StrDisplay = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.AnHS_GetAllByLoaiDuongSu2(VuAnID, 1, 0);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                String temp = "";
                string bc_dauvu = "";
                foreach (DataRow row in tbl.Rows)
                {
                    bc_dauvu = Convert.ToInt16(row["HS_BiCanDauVu"] + "") == 1 ? " (đầu vụ)" : "";
                    ////------------------------------
                    temp = "<div class='row_info'>";
                    temp += "<div class='cell_info'>" + row["TenDuongSu"].ToString() + bc_dauvu;
                    temp += String.IsNullOrEmpty(row["HS_TenToiDanh"] + "") ? "" : " -<span class='margin_left'>" + row["HS_TenToiDanh"].ToString() + "</div>";
                    temp += String.IsNullOrEmpty(row["HS_MucAn"] + "") ? "" : ",<span class='margin_left'>" + row["HS_MucAn"].ToString() + "</div>";
                    temp += "</div>";
                    //------------------------------
                    StrDisplay += temp;
                }
            }
            lttBiAn.Text = StrDisplay;
        }

        
        //----------------------------------
        #region Load quan ly ho so
        void Load_QLHoSo()
        {
            int page_size = 30000;
            int pageindex = 1;
            int loaiphieu = -1;
            DataTable tblTemp = null;
            DataRow row_data = null;
            GDTTT_QUANLYHS_BL objBL = new GDTTT_QUANLYHS_BL();
            DataTable tbl = objBL.GetByVuAn_LoaiPhieu(VuAnID, loaiphieu, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                tblTemp = tbl.Clone();
                loaiphieu = 0;//phieu muon
                DataRow[] arr = tbl.Select("LoaiPhieuID=" + loaiphieu);
                if (arr.Length > 0)
                {
                    tblTemp = arr.CopyToDataTable();
                    rptHoSo.DataSource = tblTemp;
                    rptHoSo.DataBind();
                    rptHoSo.Visible = true;
                }

                //-------------------
                loaiphieu = 1;//phieu tra hs
                arr = tbl.Select("LoaiPhieuID=" + loaiphieu, "");
                if (arr != null && arr.Length > 0)
                {
                    pnNgayTraHS.Visible = true;
                    row_data = arr[0];
                    lttNgayTraHS.Text = ((string.IsNullOrEmpty(row_data["SoPhieu"] + "")) ? "" : row_data["SoPhieu"].ToString())
                        + (string.IsNullOrEmpty(row_data["NgayTao"] + "") ? "" : ("<span style='margin-left:10px;'>" + row_data["NgayTao"] + "</span>"))
                        + (string.IsNullOrEmpty(row_data["TenCanBo"] + "") ? "" : ("<span style='margin-left:10px;'>" + row_data["TenCanBo"].ToString() + "</span>"))
                        + (string.IsNullOrEmpty(row_data["GhiChu"] + "") ? "" : ("<span style='margin-left:10px;'>" + row_data["GhiChu"].ToString() + "</span>"));
                }
                else pnNgayTraHS.Visible = false;
                //-------------------
                loaiphieu = 2;//phieu chuyen hs
                arr = tbl.Select("LoaiPhieuID=" + loaiphieu, "");
                if (arr != null && arr.Length > 0)
                {
                    pnNgayChuyenHS.Visible = true;
                    row_data = arr[0];
                    lttNgayChuyenHS.Text = ((string.IsNullOrEmpty(row_data["SoPhieu"] + "")) ? "" : row_data["SoPhieu"].ToString())
                        + (string.IsNullOrEmpty(row_data["NgayTao"] + "") ? "" : ("<span style='margin-left:10px;'>" + row_data["NgayTao"] + "</span>"))
                        + (string.IsNullOrEmpty(row_data["TenCanBo"] + "") ? "" : ("<span style='margin-left:10px;'>" + row_data["TenCanBo"].ToString() + "</span>"))
                        + (string.IsNullOrEmpty(row_data["GhiChu"] + "") ? "" : ("<span style='margin-left:10px;'>" + row_data["GhiChu"].ToString() + "</span>"));
                }
                else pnNgayChuyenHS.Visible = false;
            }
            else
            {
                rptHoSo.Visible = false;
            }
        }
        #endregion
        //----------------------------------
        #region Load to trinh
        private void LoadToTrinh()
        {
            DataTable tbl = null;
            try
            {
                tbl = GetData_ToTrinh();
            }
            catch (Exception ex) { }

            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptToTrinh.DataSource = tbl;
                rptToTrinh.DataBind();
                rptToTrinh.Visible = true;
            }
            else
                rptToTrinh.Visible = false;
        }
        DataTable GetData_ToTrinh()
        {
            DataTable tblTemp = null;
            DataRow newrow = null;
            string temp = "", tenlanhdao = "";

            
            Decimal HosoID = String.IsNullOrEmpty(Request["hsid"] + "") ? 0 : Convert.ToDecimal(Request["hsid"] + "");
            GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
            DataTable tbl = oBL.VUAN_TUHINH_TOTRINH(HosoID);

            if (tbl != null && tbl.Rows.Count > 0)
            {
                tblTemp = tbl.Clone();
                DataRow[] arr = tbl.Select("", "NgayTrinh asc, ThuTuCapTrinh asc");
                foreach (DataRow row in arr)
                {
                    temp = row["TENTINHTRANG"] + "";
                    tenlanhdao = row["TENLANHDAO"] + "";
                    row["StrNgayTrinh"] = "Ngày trình: " + row["StrNgayTrinh"] + "";
                    //--------------------
                    newrow = tblTemp.NewRow();
                    foreach (DataColumn cl in tbl.Columns)
                        newrow[cl.ColumnName] = row[cl.ColumnName];

                    newrow["TENTINHTRANG"] = row["TENTINHTRANG"] + ""
                                        + (String.IsNullOrEmpty(tenlanhdao) ? "" : (" " + tenlanhdao));
                    tblTemp.Rows.Add(newrow);

                    //------------------------------
                    temp = row["NgayTra"] + "";
                    if (!String.IsNullOrEmpty(temp))
                    {
                        newrow = tblTemp.NewRow();
                        newrow["StrNgayTrinh"] = "Ngày trả: " + row["NgayTra"] + "";

                        temp = row["TENTINHTRANG"].ToString();
                        tenlanhdao = temp.Replace("Trình ", "").Replace("Báo cáo ", "");

                        newrow["TENTINHTRANG"] = tenlanhdao + " cho ý kiến: "
                                + (String.IsNullOrEmpty(row["CapTrinhTiep"] + "") ? "" : (row["CapTrinhTiep"].ToString()))
                                + (String.IsNullOrEmpty(row["CapTrinhTiep"] + "") ? "" : "<br/>") + (row["YKienLanhDao"] + "");
                        tblTemp.Rows.Add(newrow);
                    }
                }
            }
            return tblTemp;
        }

        #endregion
        
                
    }

}
