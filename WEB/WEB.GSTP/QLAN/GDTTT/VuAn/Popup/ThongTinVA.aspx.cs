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
    public partial class ThongTinVA : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrentUserID = 0;
        public Decimal VuAnID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrintContent);

            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");          
            VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");           
            else
            {
                if (!IsPostBack)
                {
                    if (VuAnID > 0)
                    {
                        GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                        LoadThongTinVuAn(obj);
                        //---------------------------
                        try
                        {
                            LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, txtVuAn_NguyenDon);
                            LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.BIDON, txtVuAn_BiDon);
                        }
                        catch (Exception ex) { }
                        //-----------------------
                        #region Lay an quoc hoi
                        try
                        {
                            decimal temp_id = (string.IsNullOrEmpty(obj.ISANQUOCHOI + "")) ? 0 : (decimal)obj.ISANQUOCHOI;
                            if (temp_id > 0)
                            {
                                Load_AnQuocHoi(VuAnID);
                                //------------------------------
                                LoadDsThongBaoTT_TLDon();
                            }else pnAnQH.Visible = pnThongBaoTL.Visible = pnThongBaoTT.Visible = false;
                        }
                        catch (Exception ex) { pnAnQH.Visible = pnThongBaoTL.Visible = pnThongBaoTT.Visible = false; }
                        #endregion
                        //-----------------------------
                        try
                        {
                            Load_AnChiDao(VuAnID);
                        }
                        catch (Exception ex) { }
                        //------------------------------
                        try
                        {
                            Load_TTV_LanhDao(obj);
                        }
                        catch (Exception ex) { }
                        //--------------------
                        try
                        {
                            Load_QLHoSo();
                        }
                        catch (Exception ex) { }
                        //----------------------
                        try
                        {
                            LoadToTrinh();
                        }
                        catch (Exception ex) { }
                        
                        try
                        {
                            Load_GQDon(obj);
                        }
                        catch (Exception ex) { }
                        //----------------------
                        try
                        {
                            Load_XetXuGDTTT(obj);
                        }
                        catch (Exception ex) { }
                    }
                }
            }
        }
        void Load_AnChiDao(Decimal VuAnID)
        {
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable tbl = oBL.DANHSACHDONCHIDAO_ByVuAnID(VuAnID, 2);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptChiDao.DataSource = tbl;
                rptChiDao.DataBind();
                pnAnChiDao.Visible = true;
            }
        }
        void LoadThongTinVuAn(GDTTT_VUAN obj)
        {
            string temp = "";
            string temp_str = "";
            decimal temp_id = 0;            
            if (obj != null)
            {
                try
                {
                    if (!String.IsNullOrEmpty(obj.QHPL_TEXT + ""))
                    {
                        lttQHPL.Text = obj.QHPL_TEXT;
                    }
                    else if (obj.QHPL_DINHNGHIAID != null && obj.QHPL_DINHNGHIAID > 0)
                    {
                        GDTTT_DM_QHPL oQHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == obj.QHPL_DINHNGHIAID).FirstOrDefault();
                        lttQHPL.Text = (string.IsNullOrEmpty(obj.QHPL_DINHNGHIAID + "")) ? "" : oQHPL.TENQHPL;                        
                    }
                }
                catch (Exception ex) { }
                //--------------------------
                #region loai an
                temp_str = "";
                temp_id = String.IsNullOrEmpty(obj.LOAIAN + "") ? 0 : (decimal)obj.LOAIAN;
                if (temp_id > 0)
                {
                    if (temp_id < 10)
                        temp_str = "0" + temp_id + "";
                    else
                        temp_str = temp_id + "";
                    switch (temp_str)
                    {
                        case ENUM_LOAIVUVIEC.AN_HINHSU:
                            lttLoaiAn.Text = "Hình sự";
                            break;
                        case ENUM_LOAIVUVIEC.AN_DANSU:
                            lttLoaiAn.Text = "Dân sự";
                            break;
                        case ENUM_LOAIVUVIEC.AN_HANHCHINH:
                            lttLoaiAn.Text = "Hành chính";
                            break;
                        case ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH:
                            lttLoaiAn.Text = "Hôn nhân gia đình";
                            break;
                        case ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI:
                            lttLoaiAn.Text = "Kinh doanh, thương mại";
                            break;
                        case ENUM_LOAIVUVIEC.AN_LAODONG:
                            lttLoaiAn.Text = "Lao động";
                            break;
                            //case ENUM_LOAIVUVIEC.AN_PHASAN:
                            //    lttLoaiAn.Text = "Phá sản";
                            //    break;
                    }
                }
                #endregion
                //------------------------------
                try
                {
                    txtVuAn_SoThuLy.Text = (String.IsNullOrEmpty(obj.SOTHULYDON + "")?"": ("Số <b>" + obj.SOTHULYDON + "</b>"))
                                            + ((String.IsNullOrEmpty(obj.NGAYTHULYDON + "") || (obj.NGAYTHULYDON == DateTime.MinValue)) ? "" : (" ngày <b>"+((DateTime)obj.NGAYTHULYDON).ToString("dd/MM/yyyy", cul)+ "</b>"));
                }
                catch (Exception ex) { }
                //------------------------------
                #region BA/QD  phuc tham
                if (obj.BAQD_CAPXETXU == 4)
                {
                    temp = temp_str = "";
                    try
                    {
                        temp = (String.IsNullOrEmpty(obj.SO_QDGDT + "")) ? "" : ("Số <b>" + obj.SO_QDGDT + "</b>");
                        temp += (String.IsNullOrEmpty(obj.NGAYQD + "") || (obj.NGAYQD == DateTime.MinValue)) ? "" : "  ngày <b>" + ((DateTime)obj.NGAYQD).ToString("dd/MM/yyyy", cul) + "</b>";
                        lttBanAnDenghi.Text = temp;
                    }
                    catch (Exception ex) { }

                    DM_TOAAN objTA = null;
                    temp_id = String.IsNullOrEmpty(obj.TOAQDID + "") ? 0 : (decimal)obj.TOAQDID;
                    if (temp_id > 0)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAQDID).Single();
                        lttToaXuDenghi.Text = objTA.MA_TEN;
                    }
                    //--BA PT neu co
                    string toa_PT = "", soPT = "", ngaypt = "";
                    decimal toaptID = 0;
                    ngaypt = (String.IsNullOrEmpty(obj.NGAYXUPHUCTHAM + "") || (obj.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : "  ngày <b>" + ((DateTime)obj.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul) + "</b>";
                    soPT = (String.IsNullOrEmpty(obj.SOANPHUCTHAM + "")) ? "" : ("Số <b>" + obj.SOANPHUCTHAM + "</b>");
                    toaptID = String.IsNullOrEmpty(obj.TOAPHUCTHAMID + "") ? 0 : (decimal)obj.TOAPHUCTHAMID;
                    if (toaptID > 0)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAPHUCTHAMID).Single();
                        toa_PT = " tại "+ objTA.MA_TEN;
                    }
                    lttBanAnPT.Text = soPT + ngaypt + toa_PT;
                    if (String.IsNullOrEmpty(lttBanAnPT.Text.Trim()))
                        pnAnPT.Visible = false;
                    else pnAnPT.Visible = true;

                    //-----ST neu co-------------
                    string toa_ST = "", soST = "", ngayST = "";
                    decimal toaST_id = 0;
                    ngayST = (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : "  ngày <b>" + ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul) + "</b>";
                    soST = (String.IsNullOrEmpty(obj.SOANSOTHAM + "")) ? "" : ("Số <b>" + obj.SOANSOTHAM + "</b>");
                    toaST_id = String.IsNullOrEmpty(obj.TOAANSOTHAM + "") ? 0 : (decimal)obj.TOAANSOTHAM;
                    if (toaST_id > 0)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAANSOTHAM).Single();
                        toa_ST = " tại " + objTA.MA_TEN;
                    }
                    lttBanAnST.Text = soST + ngayST + toa_ST;
                    if (String.IsNullOrEmpty(lttBanAnST.Text.Trim()))
                        pnAnST.Visible = false;
                    else pnAnST.Visible = true;
                }
                else if (obj.BAQD_CAPXETXU == 2)
                {
                    temp = temp_str = "";
                    try
                    {
                        temp = (String.IsNullOrEmpty(obj.SOANSOTHAM + "")) ? "" : ("Số <b>" + obj.SOANSOTHAM + "</b>");
                        temp += (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : "  ngày <b>" + ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul) + "</b>";
                        lttBanAnDenghi.Text = temp;
                    }
                    catch (Exception ex) { }

                    DM_TOAAN objTA = null;
                    temp_id = String.IsNullOrEmpty(obj.TOAANSOTHAM + "") ? 0 : (decimal)obj.TOAANSOTHAM;
                    if (temp_id > 0)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAANSOTHAM).Single();
                        lttToaXuDenghi.Text = objTA.MA_TEN;
                    }
                    pnAnPT.Visible = pnAnST.Visible = false;
                }
                else
                {
                    try
                    {
                        temp = (String.IsNullOrEmpty(obj.SOANPHUCTHAM + "")) ? "" : ("Số <b>" + obj.SOANPHUCTHAM + "</b>");
                        temp += (String.IsNullOrEmpty(obj.NGAYXUPHUCTHAM + "") || (obj.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : "  ngày <b>" + ((DateTime)obj.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul) + "</b>";
                        lttBanAnDenghi.Text = temp;
                    }
                    catch (Exception ex) { }

                    DM_TOAAN objTA = null;
                    temp_id = String.IsNullOrEmpty(obj.TOAPHUCTHAMID + "") ? 0 : (decimal)obj.TOAPHUCTHAMID;
                    if (temp_id > 0)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAPHUCTHAMID).Single();
                        lttToaXuDenghi.Text = objTA.MA_TEN;
                    }
                    //------------------
                    string toa_ST = "", soST = "", ngayST = "";
                    decimal toaST_id = 0;
                    ngayST = (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : "  ngày <b>" + ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul) + "</b>";
                    soST = (String.IsNullOrEmpty(obj.SOANSOTHAM + "")) ? "" : ("Số <b>" + obj.SOANSOTHAM + "</b>");
                    toaST_id = String.IsNullOrEmpty(obj.TOAANSOTHAM + "") ? 0 : (decimal)obj.TOAANSOTHAM;
                    if (toaST_id > 0)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAANSOTHAM).Single();
                        toa_ST = " tại " + objTA.MA_TEN;
                    }
                    lttBanAnST.Text = soST + ngayST + toa_ST;
                    if (String.IsNullOrEmpty(lttBanAnST.Text.Trim()))
                        pnAnST.Visible = false;
                    else pnAnST.Visible = true;

                    pnAnPT.Visible = false;
  
                }
                
                #endregion
                //------------------------
                lttVuAn_NguoiKhieuNai.Text = (string.IsNullOrEmpty(obj.ARRNGUOIKHIEUNAI + ""))? obj.NGUOIKHIEUNAI: obj.ARRNGUOIKHIEUNAI;

                //---------------------------
                lttGhiChu.Text = obj.GHICHU + "";
            }
        }

        void Load_AnQuocHoi(Decimal VuAnID)
        {
            Decimal NhomAnQH = 1023;
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            //DataTable tbl = oBL.DANHSACHDONTHEOVuAnID(VuAnID);
            //lay cac đon co loai= CV+don , trang thai = da nhan theo vu an id
            DataTable tbl = oBL.GetAllByVuAn_TrangThaiChuyenDon(VuAnID, 2, 3, NhomAnQH);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptCQChuyenDonQH.DataSource = tbl;
                rptCQChuyenDonQH.DataBind();
                pnAnQH.Visible = true;
            }
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
                lttTP.Text= objCB.HOTEN;
            }
            //----------------------------
            temp_id = (String.IsNullOrEmpty(obj.THAMTRAVIENID + "")) ? 0 : Convert.ToDecimal(obj.THAMTRAVIENID);
            if (temp_id > 0)
            {
                objCB = dt.DM_CANBO.Where(x => x.ID == temp_id).Single();
                lttTTV.Text= objCB.HOTEN ;
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
            temp_str =(String.IsNullOrEmpty(obj.NGAYTTVNHAN_THS + "") || (obj.NGAYTTVNHAN_THS == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTTVNHAN_THS).ToString("dd/MM/yyyy", cul);
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
            pnTTVNhanHS.Visible = !String.IsNullOrEmpty(temp_str);

            #endregion
        }
        void LoadDuongSu(Decimal VuAnID, string tucachtt, Literal control_display)
        {
            string StrDisplay = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(VuAnID, tucachtt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    if (!String.IsNullOrEmpty(StrDisplay + ""))
                        StrDisplay += ", " + row["TenDuongSu"].ToString();
                    else
                        StrDisplay = row["TenDuongSu"].ToString();
                }
            }
            control_display.Text = StrDisplay;
        }

        //----------------------------------
        #region Load quan ly ho so
        void Load_QLHoSo()
        {
            int page_size = 30000;
            int pageindex = 1;
            int loaiphieu =-1;
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
            string temp = "", tenlanhdao = "", trunggian = "";
            
            Decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            DataTable tbl = oBL.VUAN_TOTRINH(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                tblTemp = tbl.Clone();
                DataRow[] arr = tbl.Select("", "NgayTrinh asc, ThuTuCapTrinh asc");
                foreach (DataRow row in arr)
                {
                    temp = row["TENTINHTRANG"] + "";
                    //decode(TINHTRANGID, 7, ' PCA ', 8, ' Chánh án ', 6, ' TP ', 12, decode((select chucvuid from DM_CANBO  where id = lanhdaoid), 74, ' PCA ', 45, 'Chánh án', ' TP '))
                    if (row["TinhTrangID"].ToString() == "12" || row["TinhTrangID"].ToString() == "11")
                    {
                        if (row["chucvuid"].ToString() == "74")
                            tenlanhdao = "PCA ";
                        else if (row["chucvuid"].ToString() == "45")
                            tenlanhdao = "CA ";
                        else
                            if (row["chucdanhid"].ToString() == "486")
                                tenlanhdao = "TP ";
                            else 
                                tenlanhdao = "";
                        tenlanhdao = tenlanhdao + row["TENLANHDAO"] + "";
                    }
                    else
                        tenlanhdao = row["TENLANHDAO"] + "";
                    row["StrNgayTrinh"] = "Ngày trình: " + row["StrNgayTrinh"] + "";
                    //--------------------
                    newrow = tblTemp.NewRow();
                    foreach (DataColumn cl in tbl.Columns)
                        newrow[cl.ColumnName] = row[cl.ColumnName];
                   
                    newrow["TENTINHTRANG"] = row["TENTINHTRANG"] + ""
                                        + (String.IsNullOrEmpty(tenlanhdao)? "": (" " + tenlanhdao));
                    tblTemp.Rows.Add(newrow);

                    //------------------------------
                    temp = row["NgayTra"] + "";
                    if (!String.IsNullOrEmpty(temp))
                    {
                        newrow = tblTemp.NewRow();
                        newrow["StrNgayTrinh"] = "Ngày trả: " + row["NgayTra"] + "";

                        temp = row["TENTINHTRANG"].ToString();
                        if (row["TinhTrangID"].ToString() == "12" || row["TinhTrangID"].ToString() == "11")
                        {
                            if (row["chucvuid"].ToString() == "74")
                                trunggian = "PCA ";
                            else if (row["chucvuid"].ToString() == "45")
                                trunggian = "CA ";
                            else
                                if (row["chucdanhid"].ToString() == "486")
                                trunggian = "TP ";
                            else
                                trunggian = "";
                            trunggian = trunggian + row["TENLANHDAO"] + "";
                            tenlanhdao = temp.Replace(row["TENTINHTRANG"]+"", trunggian);
                        }
                        else
                            tenlanhdao = temp.Replace("Trình ", "").Replace("Báo cáo ", "");

                        newrow["TENTINHTRANG"] = tenlanhdao +" cho ý kiến: "
                                + (String.IsNullOrEmpty(row["YKienLanhDao"] + "") ? "" : (row["YKienLanhDao"].ToString())) + " "
                                + (String.IsNullOrEmpty(row["CapTrinhTiep"] + "") ?"":(row["CapTrinhTiep"].ToString())) + " "
                                + (String.IsNullOrEmpty(row["CapTrinhTiep"]+"") ?"": "<br/>")  + (row["YKIEN"]+"");
                        tblTemp.Rows.Add(newrow);
                    }
                }
            }
            return tblTemp;
        }
     
        #endregion

        //-------------------------
        #region Load KQ Giai quyet don
        void Load_GQDon(GDTTT_VUAN objVA)
        {
            string seperate_string = "  ";
            string temp = "";
            Load_HoanTHA(objVA);
            //----------------------
            temp = "";
            String loai_gqd = Convert.ToString(objVA.GQD_LOAIKETQUA);
            if (loai_gqd == "0" || loai_gqd == "1" || loai_gqd == "2" || loai_gqd == "3" || loai_gqd == "4" || loai_gqd == null)
            {
                pnDetailKQ.Visible = true;//bjVA.GQD_KETQUA;
                if (loai_gqd == "3")
                {
                    temp = objVA.GQD_KETQUA;
                }else if(loai_gqd == "4")
                {
                    if (objVA.GDQ_SO !=null)
                    {
                        temp = (String.IsNullOrEmpty(objVA.GDQ_SO + "")) ? "" : "TB số <b>" + objVA.GDQ_SO + "</b>"
                                                      + ((string.IsNullOrEmpty(objVA.GDQ_NGAY + "") || objVA.GDQ_NGAY == DateTime.MinValue) ? "" : "  ngày <b>" + ((DateTime)objVA.GDQ_NGAY).ToString("dd/MM/yyyy", cul) + "</b>");
                    }else
                        temp = objVA.GQD_KETQUA;
                }
                
                else
                {
                    temp = (String.IsNullOrEmpty(objVA.GDQ_SO + "")) ? "" : "số <b>" + objVA.GDQ_SO + "</b>"
                               + ((string.IsNullOrEmpty(objVA.GDQ_NGAY + "") || objVA.GDQ_NGAY == DateTime.MinValue) ? "" : "  ngày <b>" + ((DateTime)objVA.GDQ_NGAY).ToString("dd/MM/yyyy", cul) + "</b>");
                }
                if (temp != "")
                    lttGQDThongTin.Text = "<span style='margin-left:5px;'>" + temp+"</span>";

                //----------nguoi ky- tham quyen xx---------------
                temp = "";
                string nguoiky = (objVA.GDQ_NGUOIKY+"").Trim();
                //Decimal temp_id = (string.IsNullOrEmpty(objVA.THAMQUYENXXGDT + "")) ? 0 : (decimal)objVA.THAMQUYENXXGDT;
                //if (temp_id > 0)
                //    temp = " (" + dt.DM_TOAAN.Where(x => x.ID == temp_id).Single().MA_TEN + ")";
                if (!string.IsNullOrEmpty(nguoiky))
                    lttGQDThongTin.Text += "<span style='margin-left:10px;'>Người ký: " + nguoiky +temp+  "</span>";
               
                switch (loai_gqd)
                {
                    case "0":
                        #region tra loi don
                        lttLoaiKQ.Text = "Trả lời đơn : ";
                        if (objVA.TRUONGHOPTHULY == 8 || objVA.TRUONGHOPTHULY == 10)
                        {
                            lttLoaiKQ.Text = "Chấp nhận khiếu nại : ";
                        }
                        #endregion
                        break;
                    case "1":
                        #region Khang nghi
                        int is_kn_vks = String.IsNullOrEmpty(objVA.ISVIENTRUONGKN + "") ? 0 : Convert.ToInt16(objVA.ISVIENTRUONGKN);
                        lttLoaiKQ.Text = "Kháng nghị <b>" + ((is_kn_vks == 0) ? "(CA) : " : "(VKS) : ") + "</b>";
                        if (objVA.TRUONGHOPTHULY == 8 || objVA.TRUONGHOPTHULY == 10)
                        {
                            lttLoaiKQ.Text = "Không chấp nhận khiếu nại : ";
                        }
                        #endregion
                        break;
                    case "2":
                        lttLoaiKQ.Text = "Xếp đơn : ";
                        break;
                    case "3":
                        lttLoaiKQ.Text = "Xử lý khác : ";
                        if (objVA.TRUONGHOPTHULY == 8 || objVA.TRUONGHOPTHULY == 10)
                        {
                            lttLoaiKQ.Text = "";
                        }
                        break;
                    case "4":
                        #region tra loi don
                        lttLoaiKQ.Text = "VKS đang giải quyết : ";
                        #endregion
                        break;
                    case null:
                        lttLoaiKQ.Text = "";
                        break;
                }
                //lttLoaiKQ.Text += ":";
                //---------------------------
                temp = "";
                temp = (string.IsNullOrEmpty(objVA.GQD_NGAYPHATHANHCV + "") || objVA.GQD_NGAYPHATHANHCV == DateTime.MinValue) ? "" : ((DateTime)objVA.GQD_NGAYPHATHANHCV).ToString("dd/MM/yyyy", cul);
                if (temp != "")
                    lttGQDThongTin.Text +=  (String.IsNullOrEmpty(temp + "") ? "" : (seperate_string + "Ngày phát hành: <b>" + temp + "</b>"));
                //---------------------------
                string ghichu = (string.IsNullOrEmpty(objVA.GQD_GHICHU + "")) ? "" : objVA.GQD_GHICHU.Trim();
                if ((ghichu != "") || (temp != ""))
                    lttGQDThongTin.Text += (string.IsNullOrEmpty(objVA.GQD_GHICHU + "")) ? "" : "<br/>Ghi chú: " + ghichu + "";
            }
            else
            {
                pnDetailKQ.Visible = false;
                lttMsg_GQD.Text = "";//"Vụ án chưa có kết quả giải quyết.";
            }
        }

        #endregion
        void Load_HoanTHA(GDTTT_VUAN objVA)
        {
            string nguoiky="", StrDisplay = "";
            int ishoanTHA = (String.IsNullOrEmpty(objVA.GQD_ISHOANTHA + "")) ? 0 : (int)objVA.GQD_ISHOANTHA;
            if (ishoanTHA > 0)
            {
                nguoiky = (string.IsNullOrEmpty(objVA.GQD_HOANTHA_TENNGUOIKY + "")) ? "" : ("Người ký <b>" + objVA.GQD_HOANTHA_TENNGUOIKY + "</b>");

                StrDisplay = (String.IsNullOrEmpty(objVA.GQD_HOANTHA_SO+ "") || (objVA.GQD_HOANTHA_SO==" "))? "" : ("Số <b>" + objVA.GQD_HOANTHA_SO + "</b>");
                if (objVA.GQD_HOANTHA_NGAY != null)
                    StrDisplay += (String.IsNullOrEmpty(objVA.GQD_HOANTHA_NGAY + "")) ? "" : ("ngày <b>" + ((DateTime)objVA.GQD_HOANTHA_NGAY).ToString("dd/MM/yyyy", cul) + "</b>");

                if ((StrDisplay != "") &&(nguoiky != ""))
                    StrDisplay += "<span style='margin-left:10px;'></span>";
               
                if (StrDisplay != "")
                    lttHoanTHA.Text = StrDisplay ;
            }
            pnHoanTHA.Visible = !String.IsNullOrEmpty(StrDisplay);
        }
        void LoadDsThongBaoTT_TLDon()
        {
            GDTTT_DON_TRALOI_BL oBL = new GDTTT_DON_TRALOI_BL();

            //-----TB tinh the------------------
            DataTable tbl = oBL.GetThongBao(VuAnID, ENUM_LOAITHONGBAO_QH.TBTINHTHE);
            if (tbl != null && tbl.Rows.Count > 0)
            {                
                rptTBTT.DataSource = tbl;
                rptTBTT.DataBind();
                pnThongBaoTT.Visible = true;
            }

            //--------TB tra loi don----------------------------
            tbl = oBL.GetThongBao(VuAnID, ENUM_LOAITHONGBAO_QH.TBKQTRALOI);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptTBTL.DataSource = tbl;
                rptTBTL.DataBind();
                pnThongBaoTL.Visible = true;
            }
        }
        //-------------------------
        #region Load xet xu GDTTT
        void Load_XetXuGDTTT(GDTTT_VUAN objVA)
        {            
            Decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            Load_ThuLyXXGDTTT(objVA);

            //----------------------------------
            GDTTT_VUAN_XETXU_BL objBL = new GDTTT_VUAN_XETXU_BL();
            DataTable tbl = objBL.XetXuGDTTT_GetByVuAnID(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                DataView view = new DataView(tbl);
                view.Sort = "NgayMoPhienToa asc";
                DataTable tblData = view.ToTable();

                rptXX.DataSource = tblData;
                rptXX.DataBind();
                pnXXGDT.Visible = true;
            }
            else
                pnXXGDT.Visible = false;  
        }
        void Load_ThuLyXXGDTTT(GDTTT_VUAN objVA)
        {
            String StrDisplay = "", date_temp = "";
            String temp_so = (string.IsNullOrEmpty(objVA.SOTHULYXXGDT + "") ? "" : "Số <b>" + objVA.SOTHULYXXGDT.ToString() + "</b>");
            int is_kn_vks = String.IsNullOrEmpty(objVA.ISVIENTRUONGKN + "") ? 0 : Convert.ToInt16(objVA.ISVIENTRUONGKN);
            
            if (string.IsNullOrEmpty(objVA.NGAYTHULYXXGDT + "") || objVA.NGAYTHULYXXGDT == DateTime.MinValue)
                date_temp = "";
            else date_temp = "ngày <b>" + ((DateTime)objVA.NGAYTHULYXXGDT).ToString("dd/MM/yyyy", cul) + "</b>";           
            StrDisplay = temp_so + (String.IsNullOrEmpty(date_temp+"") ?"": "   ") +date_temp ;
            if (StrDisplay != "")
            {
                if (is_kn_vks > 0)
                {
                    date_temp = "ngày <b>" + ((DateTime)objVA.VIENTRUONGKN_NGAY).ToString("dd/MM/yyyy", cul) + "</b>";
                    temp_so = (string.IsNullOrEmpty(objVA.VIENTRUONGKN_SO+ "") ? "" : "số <b>" + objVA.VIENTRUONGKN_SO.ToString() + "</b>");
                    if (!string.IsNullOrEmpty(temp_so))
                        temp_so += " ";
                    temp_so += date_temp;

                    StrDisplay += " do Chánh án/Viện trưởng KN theo " + temp_so;
                }
            }
            lttThuLyXXGDTTT.Text = StrDisplay;
            pnNgayThuLyXXGDT.Visible = !String.IsNullOrEmpty(StrDisplay);

            //-------------------------------
            date_temp = (string.IsNullOrEmpty(objVA.XXGDTTT_NGAYVKSTRAHS + "") || objVA.XXGDTTT_NGAYVKSTRAHS == DateTime.MinValue) ? "" :  ((DateTime)objVA.XXGDTTT_NGAYVKSTRAHS).ToString("dd/MM/yyyy", cul) ;
            pnNgayNhanHSTuVKS.Visible = !String.IsNullOrEmpty(date_temp);
            lttNgayNhanHS_VKS.Text = date_temp;
        }
        #endregion

        //protected void cmdReLoad_Click(object sender, EventArgs e)
        //{
        //  //  Decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
        //    if (VuAnID > 0)
        //    {
        //        LoadThongTinVuAn();
        //    }
        //}
        protected void cmdPrintContent_Click(object sender, EventArgs e)
        {
            System.IO.StringWriter sw = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter h = new System.Web.UI.HtmlTextWriter(sw);
            zone_vuan_info.RenderControl(h);
            string CONTENT = sw.GetStringBuilder().ToString();

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            Int32 PBID = strPBID == "" ? 0 : Convert.ToInt32(strPBID);
            object Result = new object();

            Literal Table_Str_Totals = new Literal();

            //string CONTENT = Request["zone_vuan_info"].ToString();
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=BC_THONGTINVUAN_GDKT.doc");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/msword";
            HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
            Response.Write("<html");
            Response.Write("<head>");
            Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
            Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
            Response.Write("<meta name=ProgId content=Word.Document>");
            Response.Write("<meta name=Generator content=Microsoft Word 9>");
            Response.Write("<meta name=Originator content=Microsoft Word 9>");
            Response.Write("<style>");
            Response.Write("<!-- /* Style Definitions */" +
                                          "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                          "{margin:0in;" +
                                          "margin-bottom:.0001pt;" +
                                          "mso-pagination:widow-orphan;" +
                                          "tab-stops:center 3.0in right 6.0in;" +
                                          "font-size:13.0pt;}");

            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("div.Section1 {page:Section1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");         
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header: h1;mso-header-margin:.0in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
            Response.Write("div.Section2 {page:Section2;}");


            Response.Write("</style>");
            Response.Write("<style type=text/css>" +
                " body { width: 98 %; margin-left: 1 %; min-width: 0px; overflow-y: auto; overflow-x: auto;}" +
                ".row_info {float: left; width: 100 %; vertical-align: top; margin-bottom: 3px;}" +
                ".cell_info {float: left; vertical-align: top;}" +
                ".margin_left {margin-left: 5px;}" +
                ".table_info_va {border: solid 1px #a2c2a8;border-collapse: collapse;margin: 5px 0;width: 100 %;font-size:13.0pt;}" +
                ".table_info_va td{border: solid 1px #a2c2a8;padding: 5px;line-height: 17px;text-align: left;vertical-align: middle;}" +
                ".col1 {width: 215px;font-weight: bold;}" +
                ".table_tt {border: none;border-collapse: collapse;margin: 5px 0;width: 100 %;}" +
                ".table_tt td {padding: 5px;border: none;line-height: 17px; text-align: left;vertical-align: middle;}" +
                ".table_tt td:first-child {padding-left: 0px;}" +
                "</ style >");


            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section2>");
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            htmlWrite.WriteLine(CONTENT);

            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("<div style=\"text-align:right; font-family:Times New Roman;font-size:10pt;font-style: italic;\"> Ngày xuất báo cáo:" + Convert.ToString(DateTime.Today) + "</div>");
            Response.Write("</div>");
            Response.Write("</body>");
            Response.Write("</html>");
            Response.End();
        }
    }

}
