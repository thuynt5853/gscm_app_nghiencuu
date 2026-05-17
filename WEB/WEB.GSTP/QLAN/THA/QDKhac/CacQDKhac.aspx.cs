using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHS;
using Module.Common;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BL.GSTP.THA;

namespace WEB.GSTP.QLAN.THA.QDKhac
{
    public partial class CacQDKhac : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        THA_CACQDKHAC obj = new THA_CACQDKHAC();
        decimal BiAnID = 0, VuAnID = 0, ToaAnUyThacID = 0;
        Decimal CurrUserID = 0, ToaAnID = 0;
        public string NgaySoSanh;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                if (!IsPostBack)
                {
                    if (BiAnID > 0)
                    {
                        pn.Visible = true;
                        txtNgayRaQD.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                        txtToaAn.Text = Convert.ToString(Session[ENUM_SESSION.SESSION_TENDONVI]);
                        hddToaAnID.Value = Session[ENUM_SESSION.SESSION_DONVIID] + "";
                        ToaAnUyThacID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID].ToString())) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                        LoadDrop();
                        LoadGrid();
                        CheckQuyen();
                    }
                    else
                    {
                        pn.Visible = false;
                        lbthongbao_top.Text = "Bạn cần chọn bị án để xử lý!";
                    }
                }                
            }
            else
                Response.Redirect("/Login.aspx");
        }

        void CheckQuyen()
        {
            Boolean IsOk = true;
            try
            {
                THA_THULY obj = dt.THA_THULY.Where(x => x.BIANID == BiAnID).FirstOrDefault<THA_THULY>();
                if (obj != null && obj.IS_KHONGTHA == 1)
                {
                    lttMsg.Text = "Bị án không phải thi hành án, không được có quyết định khác!";
                    cmdUpdateVuAn.Visible = false;
                    IsOk = false;
                }
                if (obj != null)
                    NgaySoSanh = ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                else
                {
                    lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                    cmdUpdateVuAn.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                cmdUpdateVuAn.Visible = false;
                IsOk = false;
            }
            //-----------------------------
            if (!IsOk)
            {
                try
                {
                    THA_BIAN_QUYETDINH objQD = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault();
                    if (objQD != null)
                        NgaySoSanh = ((DateTime)objQD.NGAYTHIHANH).ToString("dd/MM/yyyy", cul);
                    else
                    {
                        lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                        cmdUpdateVuAn.Visible = false;
                        IsOk = false;
                    }
                }
                catch (Exception ex)
                {
                    lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                    cmdUpdateVuAn.Visible = false;
                    IsOk = false;
                }
            }
        }

        #region load drop
        void LoadDrop()
        {
            LoadDropByGroupName(ddlLoaiQD, ENUM_DANHMUC.QUYETDINH_TB_THA, true);
            //------------------------
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            Decimal donvi = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable oCBDT = oDMCBBL.GetAllChanhAn_PhoCA(donvi);

            ddlNguoiki.DataSource = oCBDT;
            ddlNguoiki.DataTextField = "HOTEN";
            ddlNguoiki.DataValueField = "ID";
            ddlNguoiki.DataBind();
            ddlNguoiki.Items.Insert(0, new ListItem("-----Chọn-----", "0"));
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("------- Chọn --------", "0"));
            foreach (DataRow row in tbl.Rows)
            {
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
            }
        }
       
        protected void ddlNguoiki_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlNguoiki.SelectedValue != "0")
            {
                try
                {
                    Decimal CanBoID = Convert.ToDecimal(ddlNguoiki.SelectedValue);
                    Decimal ChucVuID = (Decimal)dt.DM_CANBO.Where(x => x.ID == CanBoID).SingleOrDefault().CHUCVUID;
                    hddcurID.Value = ChucVuID.ToString();

                    txtChucVu.Text = dt.DM_DATAITEM.Where(x => x.ID == ChucVuID).SingleOrDefault().TEN;
                }
                catch (Exception ex)
                {
                    lbthongbao.Text = ex.Message;
                }
            }
        }
        #endregion

        private void ResertControll()
        {
            txtGhichu.Text = "";
            txtChucVu.Text = "";
            txtNgayRaQD.Text = "";
            txtNgayThucTe.Text = "";
            txtThangThucTe.Text = "";
            txtNgay_TheoLuat.Text = "";
            txtThang_TheoLuat.Text = "";
            txtHieuLuc_TuNgay.Text = "";
            txtKetThucTheoLuat.Text = "";
            ddlNguoiki.SelectedValue = "0";
            txtNgayHieuLuc_DenNgay.Text = "";
        }
        protected void cmdResert_Click(object sender, EventArgs e)
        {
            ResertControll();
        }
       
        protected void txtHieuLuc_TuNgay_TextChanged(object sender, EventArgs e)
        {
            DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //-------------------

            int Thang_TheoLuat = (string.IsNullOrEmpty(txtThang_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtThang_TheoLuat.Text);
            int Ngay_TheoLuat = (string.IsNullOrEmpty(txtNgay_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtNgay_TheoLuat.Text);
            DateTime NgayKetThuc_TheoLuat = NgayHieuLuc_BD.AddMonths(Thang_TheoLuat).AddDays(Ngay_TheoLuat);
            txtKetThucTheoLuat.Text = NgayKetThuc_TheoLuat.ToString("dd/MM/yyyy", cul);
            //-------------------
            int Thang_ThucTe = (string.IsNullOrEmpty(txtThangThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtThangThucTe.Text);
            int Ngay_ThucTe = (string.IsNullOrEmpty(txtNgayThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtNgayThucTe.Text);
            DateTime NgayKetThuc_ThucTe = NgayHieuLuc_BD.AddMonths(Thang_ThucTe).AddDays(Ngay_ThucTe);
            txtNgayHieuLuc_DenNgay.Text = NgayKetThuc_ThucTe.ToString("dd/MM/yyyy", cul);
        }
        
        //------------------------
        protected void txtThang_TheoLuat_TextChanged(object sender, EventArgs e)
        {
            DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            int Thang_TheoLuat = (string.IsNullOrEmpty(txtThang_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtThang_TheoLuat.Text);
            int Ngay_TheoLuat = (string.IsNullOrEmpty(txtNgay_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtNgay_TheoLuat.Text);
            DateTime NgayKetThuc_TheoLuat = NgayHieuLuc_BD.AddMonths(Thang_TheoLuat).AddDays(Ngay_TheoLuat);
            txtKetThucTheoLuat.Text = NgayKetThuc_TheoLuat.ToString("dd/MM/yyyy", cul);
        }
        protected void txtNgay_TheoLuat_TextChanged(object sender, EventArgs e)
        {
            DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //-------------------
            int Thang_TheoLuat = (string.IsNullOrEmpty(txtThang_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtThang_TheoLuat.Text);
            int Ngay_TheoLuat = (string.IsNullOrEmpty(txtNgay_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtNgay_TheoLuat.Text);
            DateTime NgayKetThuc_TheoLuat = NgayHieuLuc_BD.AddMonths(Thang_TheoLuat).AddDays(Ngay_TheoLuat);
            txtKetThucTheoLuat.Text = NgayKetThuc_TheoLuat.ToString("dd/MM/yyyy", cul);
        }
        protected void txtKetThucTheoLuat_TextChanged(object sender, EventArgs e)
        {
            DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime NgayKetThuc_TheoLuat = DateTime.Parse(this.txtKetThucTheoLuat.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            double songay = (NgayKetThuc_TheoLuat - NgayHieuLuc_BD).TotalDays;
            txtThang_TheoLuat.Text = "";
            txtNgay_TheoLuat.Text = songay.ToString();
        }
        
        //-------------------------
        protected void txtThangThucTe_TextChanged(object sender, EventArgs e)
        {
            DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //-------------------
            int Thang_ThucTe = (string.IsNullOrEmpty(txtThangThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtThangThucTe.Text);
            int Ngay_ThucTe = (string.IsNullOrEmpty(txtNgayThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtNgayThucTe.Text);
            DateTime NgayKetThuc_ThucTe = NgayHieuLuc_BD.AddMonths(Thang_ThucTe).AddDays(Ngay_ThucTe);
            txtNgayHieuLuc_DenNgay.Text = NgayKetThuc_ThucTe.ToString("dd/MM/yyyy", cul);
        }
        protected void txtNgayThucTe_TextChanged(object sender, EventArgs e)
        {
            DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //-------------------
            int Thang_ThucTe = (string.IsNullOrEmpty(txtThangThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtThangThucTe.Text);
            int Ngay_ThucTe = (string.IsNullOrEmpty(txtNgayThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtNgayThucTe.Text);
            DateTime NgayKetThuc_ThucTe = NgayHieuLuc_BD.AddMonths(Thang_ThucTe).AddDays(Ngay_ThucTe);
            txtNgayHieuLuc_DenNgay.Text = NgayKetThuc_ThucTe.ToString("dd/MM/yyyy", cul);
        }
        protected void txtNgayHieuLuc_DenNgay_TextChanged(object sender, EventArgs e)
        {
            DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime NgayKetThuc_ThucTe = DateTime.Parse(this.txtNgayHieuLuc_DenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //-------------------
            double songay = (NgayKetThuc_ThucTe - NgayHieuLuc_BD).TotalDays;
            txtThangThucTe.Text = "";
            txtNgayThucTe.Text = songay.ToString();
        }

        //--------------------------------------
        #region Update data
        private void GetDataToUpdate(THA_CACQDKHAC obj)
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_BIAN oT = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
            if (oT != null)
                VuAnID = (decimal)oT.VUANID;
            
            //-------ID--------
            obj.BIANID = BiAnID;
            obj.VUANID = VuAnID;
            obj.TOAANID = Convert.ToDecimal(hddToaAnID.Value);
            obj.LOAIQUYETDINHID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);

            //----------Hieu luc tu ngay---------
            obj.MAQD = txtMaQD.Text;
            obj.SOQD = txtSoQD.Text;
            obj.NGAYQD = (String.IsNullOrEmpty(txtNgayRaQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayRaQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            
            //----------Ngày quyết đinh/hiệu lực từ ngày/den ngay-------------
            obj.HIEULUC_TUNGAY = (String.IsNullOrEmpty(txtHieuLuc_TuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);            
           
            //---------Tinh theo luật-------
            obj.THEOLUAT_SONGAYHIEULUC = String.IsNullOrEmpty(txtNgay_TheoLuat.Text.Trim()) ? 0 : Convert.ToDecimal(txtNgay_TheoLuat.Text);
            obj.THEOLUAT_SOTHANGHIEULUC = String.IsNullOrEmpty(txtThang_TheoLuat.Text.Trim()) ? 0 : Convert.ToDecimal(txtThang_TheoLuat.Text);
            obj.HIEULUCTHEOLUAT_DENNGAY = (String.IsNullOrEmpty(txtKetThucTheoLuat.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtKetThucTheoLuat.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            
            //------Tinh theo thuc te------- 
            obj.THUCTE_SONGAYHIEULUC = String.IsNullOrEmpty(txtNgayThucTe.Text.Trim()) ? 0 : Convert.ToDecimal(txtNgayThucTe.Text);
            obj.THUCTE_SOTHANGHIEULUC = String.IsNullOrEmpty(txtThangThucTe.Text.Trim()) ? 0 : Convert.ToDecimal(txtThangThucTe.Text);

            obj.HIEULUC_DENNGAY = (String.IsNullOrEmpty(txtNgayHieuLuc_DenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayHieuLuc_DenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                     
            //-----------------------------
            obj.NGUOIKY = ddlNguoiki.SelectedValue + "";
            obj.CHUCVU = txtChucVu.Text.Trim();

            obj.GHICHU = txtGhichu.Text;
        }

        protected void cmdUpdateVuAn_Click(object sender, EventArgs e)
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            Decimal CurrID = (String.IsNullOrEmpty(hddcurID.Value)) ? 0 : Convert.ToDecimal(hddcurID.Value);

            THA_CACQDKHAC obj = dt.THA_CACQDKHAC.Where(x => x.ID == CurrID ).FirstOrDefault();
            if (obj != null)
            {
                GetDataToUpdate(obj);

                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            }
            else
            {
                obj = new THA_CACQDKHAC();
                // obj.NGAYKY = DateTime.Now;
                GetDataToUpdate(obj);
                obj.NGAYTAO = DateTime.Now;               
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.THA_CACQDKHAC.Add(obj);
            }
            dt.SaveChanges();
            LoadGrid();
            ResertControll();
            lbthongbao.Text = "Cập nhật thành công!";
        }

        #endregion

        #region danh sach 
        public void LoadGrid()
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_BIAN oTp = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
            if (oTp != null)
                VuAnID = (decimal)oTp.VUANID;

            THA_CacQDKhac_BL oT = new THA_CacQDKhac_BL();
            DataTable tbl = oT.GetDataTHA_CACQDKHAC(BiAnID, VuAnID);
            if (tbl != null)
            {
                dgList.DataSource = tbl;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
                pndata.Visible = false;
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "Sua":
                        lbthongbao.Text = "";
                        hddcurID.Value = e.CommandArgument.ToString();
                        loadEdit(ID);
                       
                        break;
                    case "Xoa":
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        xoa(ID);
                        break;
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");



                string toagiaiquyetID = e.Item.Cells[7].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lbtSua.Visible = false;
                    Cls_Comon.SetButton(cmdUpdateVuAn, false);
                }
            }
        }
        private void loadEdit(decimal ID)
        {
            THA_CACQDKHAC BM = dt.THA_CACQDKHAC.Where(x => x.ID == ID).FirstOrDefault();
            if (BM != null)
            {
                txtMaQD.Text = BM.MAQD;
                //---------ToaAnID-----------
                try
                {
                    Decimal ToaAnID = (Decimal)BM.TOAANID;
                    txtToaAn.Text = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).SingleOrDefault().MA_TEN;
                }
                catch (Exception ex) { }

                // Decimal LoaiQD = (Decimal)BM.LOAIQUYETDINHID;
                try { ddlLoaiQD.SelectedValue = BM.LOAIQUYETDINHID+""; }catch(Exception ex) { }
                txtSoQD.Text = BM.SOQD;
                txtNgayRaQD.Text = String.IsNullOrEmpty(BM.NGAYQD + "") ? "" : ((DateTime)BM.NGAYQD).ToString("dd/MM/yyyy", cul);
                                
                //----------Hieu luc tu ngay--------
                txtHieuLuc_TuNgay.Text = String.IsNullOrEmpty(BM.HIEULUC_TUNGAY + "") ? "" : ((DateTime)BM.HIEULUC_TUNGAY).ToString("dd/MM/yyyy", cul);

                //------thoi han theo luat dinh/Ngay ket thuc theo luat-----               
                txtKetThucTheoLuat.Text = String.IsNullOrEmpty(BM.HIEULUCTHEOLUAT_DENNGAY + "") ? "" : ((DateTime)BM.HIEULUCTHEOLUAT_DENNGAY).ToString("dd/MM/yyyy", cul);
                txtNgay_TheoLuat.Text = (String.IsNullOrEmpty(BM.THEOLUAT_SONGAYHIEULUC + "") || (BM.THEOLUAT_SONGAYHIEULUC == 0)) ? "" : BM.THEOLUAT_SONGAYHIEULUC + "";
                txtThang_TheoLuat.Text = (String.IsNullOrEmpty(BM.THEOLUAT_SOTHANGHIEULUC + "") || (BM.THEOLUAT_SOTHANGHIEULUC == 0)) ? "" : BM.THEOLUAT_SOTHANGHIEULUC + "";

                //------Thời hạn thực tế/Ngay hieu luc day-------  
                txtNgayHieuLuc_DenNgay.Text = String.IsNullOrEmpty(BM.HIEULUC_DENNGAY + "") ? "" : ((DateTime)BM.HIEULUC_DENNGAY).ToString("dd/MM/yyyy", cul);
                txtNgayThucTe.Text = (String.IsNullOrEmpty(BM.THUCTE_SONGAYHIEULUC + "") || (BM.THUCTE_SONGAYHIEULUC == 0)) ? "" : BM.THUCTE_SONGAYHIEULUC + "";
                txtThangThucTe.Text = (String.IsNullOrEmpty(BM.THUCTE_SOTHANGHIEULUC + "") || (BM.THUCTE_SOTHANGHIEULUC == 0)) ? "" : BM.THUCTE_SOTHANGHIEULUC + "";

                //-------------------
                try { ddlNguoiki.SelectedValue = BM.NGUOIKY + ""; } catch (Exception ex) { }
                txtChucVu.Text = BM.CHUCVU;
                txtGhichu.Text = BM.GHICHU;
            }
        }
        private void xoa(decimal ID)
        {
            THA_CACQDKHAC oB = dt.THA_CACQDKHAC.Where(x => x.ID == ID).FirstOrDefault();
            if (oB != null)
            {
                dt.THA_CACQDKHAC.Remove(oB);
                dt.SaveChanges();
                ResertControll();
                LoadGrid();
                dgList.CurrentPageIndex = 0;
                lbthongbao.Text = "Xóa thành công!";
            }
        }
        #endregion
    }
}