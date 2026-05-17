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
    public partial class pBiAn : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal VuAnID = 0, NguoiTGTTID = 0;
        public String NgayXayRaVuAn;
        public int CurrentYear = 0;
        Decimal CurrentUserID = 0;
        String SessionName = "GDTTT_ReportPL".ToUpper();
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentYear = DateTime.Now.Year;
            VuAnID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");

            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    LoadDropToaAn();
                    LoadDropDiaChi();
                    LoadDropToiDanh();
                    if (VuAnID > 0)
                    {
                        try {
                            LoadThongTinVuAn(VuAnID);
                            LoadDsDuongSu();
                            int type = (String.IsNullOrEmpty(Request["type"] + "")) ? 0 : Convert.ToInt16(Request["type"] + "");
                            dropLoai.SelectedValue = type.ToString();
                            VisibleControlByLoaiDS();
                        }
                        catch (Exception exx) {  }
                    }
                    else
                        pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = false;
                }
            }
        }
        void LoadDropToaAn()
        {
            dropToaXXBAKhieuNai.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            dropToaXXBAKhieuNai.DataSource = dtTA;
            dropToaXXBAKhieuNai.DataTextField = "MA_TEN";
            dropToaXXBAKhieuNai.DataValueField = "ID";
            dropToaXXBAKhieuNai.DataBind();
            dropToaXXBAKhieuNai.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropDiaChi()
        {
            List<DM_HANHCHINH> lstTinhHuyen;
           // if (Session["DMTINHHUYEN"] == null)
                lstTinhHuyen = dt.DM_HANHCHINH.OrderBy(x => x.ARRTHUTU).ToList();
            //else
            //    lstTinhHuyen = (List<DM_HANHCHINH>)(Session["DMTINHHUYEN"]);
            ddlTinhHuyen.DataSource = lstTinhHuyen;
            ddlTinhHuyen.DataTextField = "MA_TEN";
            ddlTinhHuyen.DataValueField = "ID";
            ddlTinhHuyen.DataBind();
            ddlTinhHuyen.Items.Insert(0, new ListItem("Tỉnh/Huyện", "0"));            
        }
        private void LoadDropToiDanh()
        {
            dropToiDanh.Items.Clear();
                GDTTT_APP_BL oBL = new GDTTT_APP_BL();
                DataTable tbl = new DataTable();
                //-------------
                tbl = oBL.DieuLuat_ToiDanh_Thongke();

                dropToiDanh.DataSource = tbl;
                dropToiDanh.DataTextField = "TENTOIDANH";
                dropToiDanh.DataValueField = "ID";
                dropToiDanh.DataBind();
                dropToiDanh.Items.Insert(0, new ListItem("Chọn", "0"));                
        }
        void LoadThongTinVuAn(Decimal VuAnID)
        {
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT != null)
            {
                if (!String.IsNullOrEmpty(oT.TENVUAN + ""))
                    txtTenVuan.Text = oT.TENVUAN;
               
                //------------------------
                txtVuAn_SoThuLy.Text = oT.SOTHULYDON;
                txtVuAn_NgayThuLy.Text = (String.IsNullOrEmpty(oT.NGAYTHULYDON + "") || (oT.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);

                txtVuAn_SoBanAn.Text = oT.SOANPHUCTHAM;
                txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUPHUCTHAM + "") || (oT.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);

                hddVuAn_ToaAnID.Value = oT.TOAPHUCTHAMID + "";
                //----------------------------------
                //LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, txtVuAn_NguyenDon);
                //LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.BIDON, txtVuAn_BiDon);
                //------------------------
                if (!string.IsNullOrEmpty(oT.THAMTRAVIENID + "") && oT.THAMTRAVIENID > 0)
                {
                    lblHoTen.Visible = txtHoten.Visible = lttValidHoTen.Visible = false;
                }
            }
        }
        //void LoadDuongSu(Decimal VuAnID,string tucachtt, Literal control_display)
        //{
        //    string StrDisplay = "";
        //    GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
        //    DataTable tbl = objBL.GetByVuAnID(VuAnID, tucachtt);
        //    if (tbl != null && tbl.Rows.Count > 0)
        //    {
        //        foreach(DataRow row in tbl.Rows)
        //        {
        //            if (!String.IsNullOrEmpty(StrDisplay + ""))
        //                StrDisplay += ", " + row["TenDuongSu"].ToString();
        //            else
        //                StrDisplay = row["TenDuongSu"].ToString();
        //        }
        //    }
        //    control_display.Text = StrDisplay;
        //}
       
     
        public void LoadInfo()
        {
            lbthongbao.Text = "";
            decimal CurrDuongSuID = Convert.ToDecimal(hddCurrID.Value);
            decimal VuAn_ToaAnID = Convert.ToDecimal(hddVuAn_ToaAnID.Value);
            
            try
            {
                GDTTT_VUAN_DUONGSU obj = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == CurrDuongSuID).FirstOrDefault();
                if (obj != null)
                {
                    String tucachtt = obj.TUCACHTOTUNG;

                    if (tucachtt == ENUM_DANSU_TUCACHTOTUNG.BIDON)
                    {
                        int bicandauvu = String.IsNullOrEmpty(obj.HS_BICANDAUVU + "") ? 0 : Convert.ToInt16(obj.HS_BICANDAUVU);
                        dropLoai.SelectedValue = bicandauvu.ToString();
                    }
                    else
                    {
                        dropLoai.SelectedValue = "2";
                        txtTuCachKN.Visible = lblTuCachKN.Visible = true;
                    }

                    VisibleControlByLoaiDS();
                    //--------------------------
                    txtTuCachKN.Text = obj.HS_TUCACHTOTUNG;
                    txtHoten.Text = obj.TENDUONGSU;
                    txtDiachi.Text = obj.DIACHI;
                    txtMucAn.Text = obj.HS_MUCAN;

                    try { Cls_Comon.SetValueComboBox(ddlTinhHuyen, String.IsNullOrEmpty(obj.HUYENID + "") ? 0 : obj.HUYENID); } catch (Exception ex) { }
                    try { Cls_Comon.SetValueComboBox(dropLoaiBAKhieuNai, String.IsNullOrEmpty(obj.HS_LOAIBAKHIEUNAI + "") ? 0 : obj.HS_LOAIBAKHIEUNAI); } catch (Exception ex) { }
                    try { Cls_Comon.SetValueComboBox(dropToaXXBAKhieuNai, String.IsNullOrEmpty(obj.HS_TOARABAKHIEUNAI + "") ? 0 : obj.HS_LOAIBAKHIEUNAI); } catch (Exception ex) { }
                    txtSoBAKhieuNai.Text = obj.HS_SOBAKHIEUNAI;
                    txtNgayBAKhieuNai.Text = (String.IsNullOrEmpty(obj.HS_NGAYBAKHIEUNAI + "") || (obj.HS_NGAYBAKHIEUNAI == DateTime.MinValue)) ? "" : ((DateTime)obj.HS_NGAYBAKHIEUNAI).ToString("dd/MM/yyyy", cul);
                    txtNoiDungKhieuNai.Text = obj.HS_NOIDUNGKHIEUNAI;
                    //---------------------------
                    try{ LoadDsToiDanh(CurrDuongSuID); } catch (Exception ex) { }
                }
            }
            catch(Exception ex) { }
        }
        public void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ClearForm();
        }
        //public void cmThemToiDanh_Click(object sender, EventArgs e) {

        //    SaveData();
        //    //------------------
        //    if (dropToiDanh.SelectedValue != "0")
        //    {
        //        ThemToiDanhChoDS();
        //    }
        //}
        void ThemToiDanhChoDS()
        {
            decimal currtoidanhId = Convert.ToDecimal(dropToiDanh.SelectedValue);
            Decimal CurrDuongSuID = Convert.ToDecimal(hddCurrID.Value);
            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == VuAnID
                                                                                            && x.DUONGSUID == CurrDuongSuID
                                                                                            && x.TOIDANHID == currtoidanhId).ToList();
            if (lst == null || lst.Count == 0)
            {
                GDTTT_VUAN_DUONGSU_TOIDANH obj = new GDTTT_VUAN_DUONGSU_TOIDANH();
                obj.DUONGSUID = CurrDuongSuID;
                obj.VUANID = VuAnID;
                obj.TOIDANHID = currtoidanhId;
                obj.TENTOIDANH = dropToiDanh.SelectedItem.Text.Trim();
                dt.GDTTT_VUAN_DUONGSU_TOIDANH.Add(obj);
                dt.SaveChanges();
                lttMsgTD.Text = "Thêm tội danh thành công";
                //----------------
                dropToiDanh.SelectedIndex = 0;
                //-------------
                LoadDsToiDanh(CurrDuongSuID);
            }
        }
        
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                SaveData();
                //--------------------
                ClearForm();
                //---------------------
                hddPageIndex.Value = "1";
                LoadDsDuongSu();
                //----------------
                lbthongbao.Text = "Cập nhật thành công!";
                hddIsReloadParent.Value = "1";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
       
        void SaveData()
        {
            /*Lưu ý: Vu an duoc coi la co ho so khi da co phieu nhan.*/
            GDTTT_VUAN_DUONGSU obj = new GDTTT_VUAN_DUONGSU();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrDonID = (String.IsNullOrEmpty(hddCurrID.Value)) ? 0 : Convert.ToDecimal(hddCurrID.Value + "");

            if (CurrDonID > 0)
            {
                try
                {
                    obj = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == CurrDonID).Single<GDTTT_VUAN_DUONGSU>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN_DUONGSU();
                }
                catch (Exception ex) { obj = new GDTTT_VUAN_DUONGSU(); }
            }
            else
                obj = new GDTTT_VUAN_DUONGSU();

            obj.LOAI = 0;
            obj.VUANID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            obj.TENDUONGSU = Cls_Comon.FormatTenRieng(txtHoten.Text.Trim());
            obj.HUYENID = Convert.ToDecimal(ddlTinhHuyen.SelectedValue);
            obj.DIACHI = txtDiachi.Text.Trim();

            int loai_ds = Convert.ToInt16(dropLoai.SelectedValue);               
            if (loai_ds <2)
            {
                obj.TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.BIDON;
                obj.HS_BICANDAUVU = loai_ds;
                obj.HS_MUCAN = txtMucAn.Text.Trim();
            }
            else
            {
                obj.TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.KHAC;
                obj.HS_BICANDAUVU = 0;
                //------------------
                obj.HS_TUCACHTOTUNG = txtTuCachKN.Text.Trim();
                obj.HS_LOAIBAKHIEUNAI = Convert.ToDecimal(dropLoaiBAKhieuNai.SelectedValue);
                obj.HS_SOBAKHIEUNAI = txtSoBAKhieuNai.Text.Trim();
                obj.HS_TOARABAKHIEUNAI = Convert.ToDecimal(dropToaXXBAKhieuNai.SelectedValue);
                if (!String.IsNullOrEmpty(txtNgayBAKhieuNai.Text.Trim()))
                    obj.HS_NGAYBAKHIEUNAI = DateTime.Parse(this.txtNgayBAKhieuNai.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else obj.HS_NGAYBAKHIEUNAI = null;
                obj.HS_NOIDUNGKHIEUNAI = txtNoiDungKhieuNai.Text.Trim();
            }
            
            if (!IsUpdate)
                dt.GDTTT_VUAN_DUONGSU.Add(obj);
            dt.SaveChanges();
            Decimal CurrDuongSuID = (Decimal)obj.ID;
            hddCurrID.Value = obj.ID.ToString();
            if (dropToiDanh.SelectedValue != "0")
            {
                //them toi danh
                ThemToiDanhChoDS();
            }
            //---------------------------------
            try
            {
                if (loai_ds != 2)
                    Update_ToiDanh(obj);
                else
                {
                    //nguoi khieu nai--> ko co toi danh
                    XoaAllToiDanh(CurrDuongSuID);
                    //Xoa all toi danh --> update lai GDTT_VuAn_duongsu.HS_TenToiDanh
                    obj.HS_TENTOIDANH = "";
                    dt.SaveChanges();
                }
            }catch(Exception ex) { }
        }

        void Update_ToiDanh(GDTTT_VUAN_DUONGSU oDS)
        {
            String Str = "";
            Decimal DuongSuID = (decimal)oDS.ID;
            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == VuAnID
                                                                                         && x.DUONGSUID == DuongSuID                                                                                          
                                                                                      ).ToList();
            if (lst != null && lst.Count>0)
            {               
                foreach(GDTTT_VUAN_DUONGSU_TOIDANH item in lst)
                {
                    Str += String.IsNullOrEmpty(Str) ? "" : ", ";
                    Str += item.TENTOIDANH;
                }
            }
            oDS.HS_TENTOIDANH = Str;
            dt.SaveChanges();
        }
        void ClearForm()
        {
            hddCurrID.Value = "0";
            lbthongbao.Text = "";

            dropLoai.SelectedIndex  = 0;
            
            lblHoTen.Visible = txtHoten.Visible = lttValidHoTen.Visible = true;
            pnBiCan.Visible = true;
            txtMucAn.Text = txtHoten.Text = "";

            txtDiachi.Text = "";
            ddlTinhHuyen.SelectedIndex = 0;

            pnKhieuNai.Visible = false;
            txtTuCachKN.Visible = false;
            dropLoaiBAKhieuNai.SelectedIndex = dropToaXXBAKhieuNai.SelectedIndex = 0;
            txtSoBAKhieuNai.Text = txtNgayBAKhieuNai.Text = txtNoiDungKhieuNai.Text = "";
            txtTuCachKN.Text = "";
            try
            {
                rptToiDanh.DataSource = null;
                rptToiDanh.DataBind();
            }catch(Exception ex) { }
            rptToiDanh.Visible = false;
        }
        //---------------------------------------
        #region Load ds
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDsDuongSu();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        void LoadDsToiDanh(Decimal DuongSuID)
        {
            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == VuAnID                
                                                                                           && x.DUONGSUID == DuongSuID
                                                                                        ).ToList();
            if (lst != null && lst.Count > 0)
            {
                rptToiDanh.DataSource = lst;
                rptToiDanh.DataBind();
                rptToiDanh.Visible = true;
            }
            else rptToiDanh.Visible = false;
        }        
        protected void rptToiDanh_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            switch (e.CommandName)
            {
                case "Xoa":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    XoaToiDanh(curr_id);
                    LoadDsToiDanh(Convert.ToDecimal(hddCurrID.Value));
                    lttMsgTD.Text = "Xóa thành công!";
                    break;
            }
        }
        
        //-------------------------------------------------
        public void LoadDsDuongSu()
        {
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.AnHS_GetAllDuongSu(VuAnID, "", 2);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows.Count);
                rpt.DataSource = tbl;
                rpt.DataBind();
                pnPagingBottom.Visible = pnPagingTop.Visible = false;
                rpt.Visible = true;
            }
            else
                pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = false;
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            switch (e.CommandName)
            {
                case "Sua":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    hddCurrID.Value = curr_id.ToString();
                    LoadInfo();
                    break;
                case "Xoa":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    xoa_duongsu(curr_id);
                    break;
            }
        }
       
        void xoa_duongsu(decimal id)
        {
            Decimal curr_vuanid = 0, is_bicandauvu =0;
            GDTTT_VUAN_DUONGSU oND = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                curr_vuanid = (decimal)oND.VUANID;
                is_bicandauvu = (String.IsNullOrEmpty(oND.HS_BICANDAUVU + "")) ? 0 : (decimal)oND.HS_BICANDAUVU;
                XoaAllToiDanh(id);

                dt.GDTTT_VUAN_DUONGSU.Remove(oND);
                dt.SaveChanges();
                //-----------------------
                if(is_bicandauvu ==1)
                    Update_TenVuAn(curr_vuanid);
                //-----------------------
                hddIsReloadParent.Value = "1";
                hddPageIndex.Value = "1";

                LoadDsDuongSu();
                lbthongbao.Text = "Xóa thành công!";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }
        }
        void XoaToiDanh(Decimal currID)
        {
            GDTTT_VUAN_DUONGSU_TOIDANH item = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.ID == currID).Single();
            dt.GDTTT_VUAN_DUONGSU_TOIDANH.Remove(item);
            dt.SaveChanges();
        }
        void XoaAllToiDanh(Decimal DuongsuID)
        {
            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == VuAnID
                                                                                         && x.DUONGSUID == DuongsuID).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (GDTTT_VUAN_DUONGSU_TOIDANH item in lst)
                    dt.GDTTT_VUAN_DUONGSU_TOIDANH.Remove(item);
            }
            dt.SaveChanges();
        }
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadDsDuongSu();
            }
            catch (Exception ex) { }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDsDuongSu();
            }
            catch (Exception ex) { }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadDsDuongSu();
            }
            catch (Exception ex) { }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadDsDuongSu();
            }
            catch (Exception ex) { }
        }
        protected void dropLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            VisibleControlByLoaiDS();
        }

        void VisibleControlByLoaiDS()
        {
            if (dropLoai.SelectedValue == "2")
            {
                txtTuCachKN.Visible = lblTuCachKN.Visible = pnKhieuNai.Visible = true;
                pnBiCan.Visible = false;
            }
            else
            {
                txtTuCachKN.Visible = lblTuCachKN.Visible = pnKhieuNai.Visible = false;
                pnBiCan.Visible = true;
            }
        }
        
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadDsDuongSu();
            }
            catch (Exception ex) { }
        }
        #endregion
        void Update_TenVuAn(Decimal CurrVuAnID)
        {
            string bican_dauvu = "", bican_khieunai = "", nguoikhieunai = "", toidanh = "";
            decimal count_ds = 0;
            string tucachtt = "";
            int is_bicandauvu = 0, iskhieunai = 0;
            List<GDTTT_VUAN_DUONGSU> lst = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID).OrderBy(y => y.TUCACHTOTUNG).ToList();
            if (lst != null && lst.Count > 0)
            {
                count_ds = lst.Count;
                foreach (GDTTT_VUAN_DUONGSU ds in lst)
                {
                    tucachtt = ds.TUCACHTOTUNG + "";
                    switch (tucachtt)
                    {
                        case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                            is_bicandauvu = (string.IsNullOrEmpty(ds.HS_BICANDAUVU + "")) ? 0 : (int)ds.HS_BICANDAUVU;
                            if (is_bicandauvu == 1)
                            {
                                bican_dauvu += ((string.IsNullOrEmpty(bican_dauvu + "")) ? "" : ", ") + Cls_Comon.FormatTenRieng(ds.TENDUONGSU);
                                toidanh += ((string.IsNullOrEmpty(toidanh + "")) ? "" : ", ") + ds.HS_TENTOIDANH;
                            }
                            else
                                bican_khieunai += ((string.IsNullOrEmpty(bican_khieunai + "")) ? "" : ", ") + Cls_Comon.FormatTenRieng(ds.TENDUONGSU);
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.KHAC:
                            iskhieunai = (string.IsNullOrEmpty(ds.HS_ISKHIEUNAI + "")) ? 0 : (int)ds.HS_ISKHIEUNAI;
                            if (iskhieunai == 1)
                                nguoikhieunai += ((string.IsNullOrEmpty(nguoikhieunai + "")) ? "" : ", ") + Cls_Comon.FormatTenRieng(ds.TENDUONGSU);
                            break;
                    }
                }
            }
            //---------------------------
            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();
            if (oVA != null)
            {
                oVA.NGUYENDON = bican_dauvu;
                oVA.BIDON = bican_khieunai;
                oVA.NGUOIKHIEUNAI = nguoikhieunai;
                //------------------
                oVA.TENVUAN = bican_dauvu
                    + (String.IsNullOrEmpty(bican_dauvu + "") ? "" : (string.IsNullOrEmpty(toidanh + "") ? "" : " - "))
                    + toidanh;
                dt.SaveChanges();
            }
        }
    }
}