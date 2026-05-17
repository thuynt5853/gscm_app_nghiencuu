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
    public partial class pQLCongVan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal CongVanID=0, NguoiTGTTID = 0;
        public String NgayXayRaVuAn;
        public int CurrentYear = 0;
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentYear = DateTime.Now.Year;
            CongVanID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    try
                    {
                        LoadDropToaAn();
                        LoadTTVTheoPhongBan();
                        if (CongVanID == 0)
                        {
                            dropToaAn.SelectedIndex = 1;
                            GetNewSoCV();
                            txtNgayCV.Text = txtNgayThuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
                        }
                        else
                        {
                            hddCurrID.Value = CongVanID.ToString();
                            LoadInfoCongVan(); }

                        LoadGrid();
                    }
                    catch (Exception ex) { }
                   
                }
            }
        }
        void LoadDropToaAn()
        {
            dropToaAn.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            dropToaAn.DataSource = dtTA;
            dropToaAn.DataTextField = "MA_TEN";
            dropToaAn.DataValueField = "ID";
            dropToaAn.DataBind();
            //dropToaAn.Items.Insert(0, new ListItem("Chọn", "0"));
            dropToaAn.Items.Insert(0, new ListItem("Không chọn", "0"));
        }
        void LoadTTVTheoPhongBan()
        {
            dropTTV.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            DataTable tbl = obj.DM_CANBO_GetTTVTheoPhongBan(PhongBanID, "TTV");
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropTTV.DataSource = tbl;
                dropTTV.DataValueField = "CanBoID";
                dropTTV.DataTextField = "HoTen";
                dropTTV.DataBind();
            }
            //dropTTV.Items.Insert(0, new ListItem("Không chọn", "0"));
        }
    
        public void LoadInfoCongVan()
        {
            lbthongbao.Text = "";
            decimal ID = Convert.ToDecimal(hddCurrID.Value);
            try
            {
                GDTTT_VUAN_TRAODOICONGVAN obj = dt.GDTTT_VUAN_TRAODOICONGVAN.Where(x => x.ID == ID).Single();
                if (obj != null)
                {
                    Cls_Comon.SetValueComboBox(dropToaAn, obj.DONVIGUIID);
                    ID = (string.IsNullOrEmpty(obj.DONVIGUIID + "")) ? 0 : (decimal)obj.DONVIGUIID;
                    if (ID > 0)
                    {
                        lblTenDV.Visible = txtDonViChuyenCV.Visible = lttValidTenDV.Visible= false;
                    }
                    else
                    {
                        lblTenDV.Visible = txtDonViChuyenCV.Visible = lttValidTenDV.Visible = true;
                        txtDonViChuyenCV.Text = obj.TENDONVIGUICV;
                    }
                    //--------------------------- 
                    Decimal tempID = String.IsNullOrEmpty(obj.TTV_ID + "") ? 0 : (decimal)obj.TTV_ID;
                    Cls_Comon.SetValueComboBox(dropTTV, tempID);

                    txtNgayPhanCongTTV.Text = (String.IsNullOrEmpty(obj.NGAYPHANCONGTTV + "") || (obj.NGAYPHANCONGTTV == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYPHANCONGTTV).ToString("dd/MM/yyyy", cul);

                    //------------------
                    txtNgayThuLy.Text = (String.IsNullOrEmpty(obj.NGAYTHULY + "") || (obj.NGAYTHULY == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                    txtSoThuLy.Text = obj.SOTHULY + "";

                    //------------------
                    txtNgayCV.Text = (String.IsNullOrEmpty(obj.NGAYCV + "") || (obj.NGAYCV == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYCV).ToString("dd/MM/yyyy", cul);
                    txtSoCV.Text = obj.SOCV + "";

                    //------------------
                    txtNgaynhan.Text = (String.IsNullOrEmpty(obj.NGAYNHAN + "") || (obj.NGAYNHAN == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYNHAN).ToString("dd/MM/yyyy", cul);

                    txtNoiDung.Text = obj.NOIDUNG + "";
                    txtGhiChu.Text = obj.GHICHU + "";
                }
            }
            catch(Exception ex) { }
        }
        public void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ClearForm();
        }
       
        void SaveData()
        {
            /*Lưu ý: Vu an duoc coi la co ho so khi da co phieu nhan.*/
            GDTTT_VUAN_TRAODOICONGVAN obj = new GDTTT_VUAN_TRAODOICONGVAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrCongVanID = (String.IsNullOrEmpty(hddCurrID.Value)) ? 0 : Convert.ToDecimal(hddCurrID.Value + "");
            DateTime date_temp;
            if (CurrCongVanID > 0)
            {
                try
                {
                    obj = dt.GDTTT_VUAN_TRAODOICONGVAN.Where(x => x.ID == CurrCongVanID).Single<GDTTT_VUAN_TRAODOICONGVAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN_TRAODOICONGVAN();
                }
                catch (Exception ex) { obj = new GDTTT_VUAN_TRAODOICONGVAN(); }
            }
            else
                obj = new GDTTT_VUAN_TRAODOICONGVAN();
            
            //obj.VUANID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            obj.DONVIGUIID = Convert.ToDecimal(dropToaAn.SelectedValue);
            if (obj.DONVIGUIID == 0)
                obj.TENDONVIGUICV = txtDonViChuyenCV.Text.Trim();
            else obj.TENDONVIGUICV = dropToaAn.SelectedItem.Text;
            
            //-----------------------------
            obj.TTV_ID = Convert.ToDecimal(dropTTV.SelectedValue);
            obj.TTV_HOTEN = dropTTV.SelectedItem.Text;
            date_temp = (String.IsNullOrEmpty(txtNgayPhanCongTTV.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayPhanCongTTV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYPHANCONGTTV = date_temp;
            
            //--------------------------------
            date_temp = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYTHULY = date_temp;
            obj.SOTHULY = txtSoThuLy.Text.Trim();

            obj.SOCV = txtSoCV.Text.Trim();
            date_temp = (String.IsNullOrEmpty(txtNgayCV.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYCV = date_temp;

            date_temp = (String.IsNullOrEmpty(txtNgaynhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaynhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYNHAN = date_temp;

            obj.NOIDUNG = txtNoiDung.Text.Trim();
            obj.GHICHU = txtGhiChu.Text.Trim();
            if (!IsUpdate)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO_ID = UserID;
                obj.NGUOITAO_HOTEN = UserName;
                dt.GDTTT_VUAN_TRAODOICONGVAN.Add(obj);
            }
            dt.SaveChanges();
            hddCurrID.Value = obj.ID.ToString();
        }
        void ClearForm()
        {
            hddCurrID.Value = "0";
            lbthongbao.Text = "";
            txtSoThuLy.Text = txtSoCV.Text = "";
            txtGhiChu.Text = txtNoiDung.Text = "";

            dropTTV.SelectedIndex = dropToaAn.SelectedIndex = 0;
            lblTenDV.Visible = txtDonViChuyenCV.Visible = lttValidTenDV.Visible = false;
            txtDonViChuyenCV.Text = "";
            txtNgayPhanCongTTV.Text = "";
            txtNgaynhan.Text= txtNgayCV.Text =txtNgayThuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
            if (CongVanID==0)
                GetNewSoCV();
        }        

        //---------------------------------------
        #region Load ds
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadGrid()
        {
            String textsearch = txtTextSearch.Text.Trim();
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            //DataTable tbl = objBL.AnTraoDoiCV_Search(VuAnID, textsearch, pageindex, page_size);
            //if (tbl != null && tbl.Rows.Count > 0)
            //{
            //    int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

            //    #region "Xác định số lượng trang"
            //    hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
            //    lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            //    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
            //                 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            //    #endregion

            //    rpt.DataSource = tbl;
            //    rpt.DataBind();
            //    pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = cmdPrinDS.Visible = true;
            //}
            //else
                pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = cmdPrinDS.Visible = false;
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    hddCurrID.Value = curr_id.ToString();
                    LoadInfoCongVan();
                    break;
                case "Xoa":
                    xoa(curr_id);
                    break;
            }
        }
        void xoa(decimal id)
        {
            //GDTTT_QUANLYHS oND = dt.GDTTT_QUANLYHS.Where(x => x.ID == id).FirstOrDefault();
            //if (oND != null)
            //{
            //    dt.GDTTT_QUANLYHS.Remove(oND);
            //    try
            //    {
            //        GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
            //        objVA.ISHOSO = (string.IsNullOrEmpty(objVA.ISHOSO+""))?0: (objVA.ISHOSO-1);
            //    }catch(Exception ex) { }

            //    dt.SaveChanges();
            //    hddPageIndex.Value = "1";
            //    LoadGrid();
            //    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Xóa thành công!");
            //}
        }
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { }
        }
        
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            //String textsearch = txtTextSearch.Text.Trim();
            //int page_size = 2000000000;
            //String SessionName = "GDTTT_ReportPL".ToUpper();
            //Session[SS_TK.TENBAOCAO] = "Quản lý hồ sơ";

            //GDTTT_QUANLYHS_BL objBL = new GDTTT_QUANLYHS_BL();            
            //DataTable tblData =  objBL.GetAllPaging(VuAnID, textsearch, 1, page_size);
            //if (tblData != null && tblData.Rows.Count > 0)
            //    Session[SessionName] = tblData;
        }
        
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { }
        }
        #endregion
        protected void txtNgayCV_TextChanged(object sender, EventArgs e)
        {
            GetNewSoCV();
        }

        void GetNewSoCV()
        {
            DateTime Ngay = (DateTime)((String.IsNullOrEmpty(txtNgayCV.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(this.txtNgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));
            GDTTT_VUAN_TRAODOICONGVAN_BL objBL = new GDTTT_VUAN_TRAODOICONGVAN_BL();
            Decimal SoCV = objBL.GetLastSo(Ngay);
            txtSoCV.Text = SoCV + "";
        }
       

        protected void cmdSave_Click(object sender, EventArgs e)
        {
            try
            {
                SaveData();
                //----------------
                lbthongbao.Text = "Cập nhật thành công!";
                hddIsReloadParent.Value = "1";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        

        protected void dropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropToaAn.SelectedValue == "0")
                lblTenDV.Visible = txtDonViChuyenCV.Visible = lttValidTenDV.Visible = true;
            else
                lblTenDV.Visible = txtDonViChuyenCV.Visible = lttValidTenDV.Visible = false;
            txtNgayPhanCongTTV.Text = "";
        }
    }
}