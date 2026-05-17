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

namespace WEB.GSTP.QLAN.THA.UyThacTHA
{
    public partial class QuyetDinh : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        THA_UYTHAC_QUYETDINH obj = new THA_UYTHAC_QUYETDINH();
        decimal BiAnID = 0, VuAnID = 0, ToaAnUyThacID = 0;
        Decimal CurrUserID = 0;
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
                        load_ddlNguoiki();

                        txtNgayRaQD.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                        txtUy_thac.Text = Convert.ToString(Session[ENUM_SESSION.SESSION_TENDONVI]);
                        ToaAnUyThacID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID].ToString())) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

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
            THA_BIAN oBA = dt.THA_BIAN.Where(x => x.ID == BiAnID).FirstOrDefault();
            THA_VUAN oTHVA = dt.THA_VUAN.Where(x => x.ID == oBA.VUANID).FirstOrDefault();
            if (oTHVA != null)
            {
                if (oTHVA.IDVUANHETHONG == null || oTHVA.IDVUANHETHONG == 0 || oTHVA.TOA_GIAIQUYET_ID != oTHVA.BA_ST_TOAANID)
                {
                    lttMsg.Text = "Không phải vụ án gốc không được ủy thác. Bạn hãy kiểm tra lại!";
                    cmdUpdate.Visible = false;
                    IsOk = false;
                }
                else
                {
                    lttMsg.Text = "";
                    cmdUpdate.Visible = true;
                    IsOk = false;
                }
            }
            try
            {
                THA_THULY obj = dt.THA_THULY.Where(x => x.BIANID == BiAnID).FirstOrDefault<THA_THULY>();
                if(obj != null && obj.IS_KHONGTHA == 1)
                {
                    lttMsg.Text = "Bị án không phải thi hành án, không được ủy thác!";
                    cmdUpdate.Visible = false;
                    IsOk = false;
                }
                if (obj != null)
                    NgaySoSanh = ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                else
                {
                    lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                    cmdUpdate.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                cmdUpdate.Visible = false;
                IsOk = false;
            }

            //-----------------------------
            if (!IsOk)
            {
                try
                {
                    THA_BIAN_QUYETDINH objQD = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault();
                    if (objQD != null)
                    {
                        lttMsg.Text = "Bị án đã có quyết định thi hành án, không được thực hiện thao tác này. Bạn hãy kiểm tra lại!";
                        cmdUpdate.Visible = false;
                        IsOk = false;
                    }
                }
                catch (Exception ex)
                {
                    lttMsg.Text = "Bị án đã có quyết định thi hành án, không được thực hiện thao tác này Bạn hãy kiểm tra lại!";
                    cmdUpdate.Visible = false;
                    IsOk = false;
                }
            }
        }

        #region LoadNguoiKi- chuc vu 
        public void load_ddlNguoiki()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            Decimal donvi = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable oCBDT = oDMCBBL.GetAllChanhAn_PhoCA(donvi);

            ddlNguoiki.DataSource = oCBDT;
            ddlNguoiki.DataTextField = "HOTEN";
            ddlNguoiki.DataValueField = "ID";
            ddlNguoiki.DataBind();
            ddlNguoiki.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }
        protected void ddlNguoiki_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlNguoiki.SelectedValue != "0")
            {
                try
                {
                    Decimal CanBoID = Convert.ToDecimal(ddlNguoiki.SelectedValue);
                    Decimal ChucVuID = (Decimal)dt.DM_CANBO.Where(x => x.ID == CanBoID).SingleOrDefault().CHUCVUID;
                    //hddcurID.Value = ChucVuID.ToString();

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
            //chuc vu-----------
            txtChucVu.Text = "";
            ddlNguoiki.SelectedValue = "0";
            txtGhichu.Text = "";

            //ngay thang--------

            txtHieuLuc_TuNgay.Text = "";
            //txtNgay_TheoLuat.Text = "";
            //txtNgayHieuLuc_DenNgay.Text = "";
            //txtNgayRaQD.Text = "";
            //txtNgayThucTe.Text = "";
            //txtThangThucTe.Text = "";
            //txtThang_TheoLuat.Text = "";

            ////------------------
            //txtKetThucTheoLuat.Text = "";
            txtQDvaTB.Text = "";
            txtSoQuyDinh.Text = "";
            txtToaAnUyThac.Text = "";
            //txtUy_thac.Text = "";
            txtMaQD.Text = "";

        }
        protected void cmdResert_Click(object sender, EventArgs e)
        {
            ResertControll();
        }
        #region load /Time
        protected void txtNgayRaQD_TextChanged(object sender, EventArgs e)
        {
            //if (!String.IsNullOrEmpty(txtNgayRaQD.Text))
            //{
            //    txtHieuLuc_TuNgay.Text = txtNgayRaQD.Text;
            //    DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            //    //-------------------
            //    int Thang_TheoLuat = (string.IsNullOrEmpty(txtThang_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtThang_TheoLuat.Text);
            //    int Ngay_TheoLuat = (string.IsNullOrEmpty(txtNgay_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtNgay_TheoLuat.Text);
            //    DateTime NgayKetThuc_TheoLuat = NgayHieuLuc_BD.AddMonths(Thang_TheoLuat).AddDays(Ngay_TheoLuat);
            //    txtKetThucTheoLuat.Text = NgayKetThuc_TheoLuat.ToString("dd/MM/yyyy", cul);
            //    //-------------------
            //    int Thang_ThucTe = (string.IsNullOrEmpty(txtThangThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtThangThucTe.Text);
            //    int Ngay_ThucTe = (string.IsNullOrEmpty(txtNgayThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtNgayThucTe.Text);
            //    DateTime NgayKetThuc_ThucTe = NgayHieuLuc_BD.AddMonths(Thang_ThucTe).AddDays(Ngay_ThucTe);
            //    txtNgayHieuLuc_DenNgay.Text = NgayKetThuc_ThucTe.ToString("dd/MM/yyyy", cul);
            //}
        }
        protected void txtHieuLuc_TuNgay_TextChanged(object sender, EventArgs e)
        {
            //DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            ////-------------------

            //int Thang_TheoLuat = (string.IsNullOrEmpty(txtThang_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtThang_TheoLuat.Text);
            //int Ngay_TheoLuat = (string.IsNullOrEmpty(txtNgay_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtNgay_TheoLuat.Text);
            //DateTime NgayKetThuc_TheoLuat = NgayHieuLuc_BD.AddMonths(Thang_TheoLuat).AddDays(Ngay_TheoLuat);
            //txtKetThucTheoLuat.Text = NgayKetThuc_TheoLuat.ToString("dd/MM/yyyy", cul);
            ////-------------------
            //int Thang_ThucTe = (string.IsNullOrEmpty(txtThangThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtThangThucTe.Text);
            //int Ngay_ThucTe = (string.IsNullOrEmpty(txtNgayThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtNgayThucTe.Text);
            //DateTime NgayKetThuc_ThucTe = NgayHieuLuc_BD.AddMonths(Thang_ThucTe).AddDays(Ngay_ThucTe);
            //txtNgayHieuLuc_DenNgay.Text = NgayKetThuc_ThucTe.ToString("dd/MM/yyyy", cul);
        }

        //------------------------
        protected void txtThang_TheoLuat_TextChanged(object sender, EventArgs e)
        {
            //DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            //int Thang_TheoLuat = (string.IsNullOrEmpty(txtThang_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtThang_TheoLuat.Text);
            //int Ngay_TheoLuat = (string.IsNullOrEmpty(txtNgay_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtNgay_TheoLuat.Text);
            //DateTime NgayKetThuc_TheoLuat = NgayHieuLuc_BD.AddMonths(Thang_TheoLuat).AddDays(Ngay_TheoLuat);
            //txtKetThucTheoLuat.Text = NgayKetThuc_TheoLuat.ToString("dd/MM/yyyy", cul);
        }
        protected void txtNgay_TheoLuat_TextChanged(object sender, EventArgs e)
        {
            //DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            ////-------------------
            //int Thang_TheoLuat = (string.IsNullOrEmpty(txtThang_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtThang_TheoLuat.Text);
            //int Ngay_TheoLuat = (string.IsNullOrEmpty(txtNgay_TheoLuat.Text.Trim())) ? 0 : Convert.ToInt16(txtNgay_TheoLuat.Text);
            //DateTime NgayKetThuc_TheoLuat = NgayHieuLuc_BD.AddMonths(Thang_TheoLuat).AddDays(Ngay_TheoLuat);
            //txtKetThucTheoLuat.Text = NgayKetThuc_TheoLuat.ToString("dd/MM/yyyy", cul);
        }
        protected void txtKetThucTheoLuat_TextChanged(object sender, EventArgs e)
        {
            //DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //DateTime NgayKetThuc_TheoLuat = DateTime.Parse(this.txtKetThucTheoLuat.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            //double songay = (NgayKetThuc_TheoLuat - NgayHieuLuc_BD).TotalDays;
            //txtThang_TheoLuat.Text = "";
            //txtNgay_TheoLuat.Text = songay.ToString();
        }

        //-------------------------
        protected void txtThangThucTe_TextChanged(object sender, EventArgs e)
        {
            //DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            ////-------------------
            //int Thang_ThucTe = (string.IsNullOrEmpty(txtThangThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtThangThucTe.Text);
            //int Ngay_ThucTe = (string.IsNullOrEmpty(txtNgayThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtNgayThucTe.Text);
            //DateTime NgayKetThuc_ThucTe = NgayHieuLuc_BD.AddMonths(Thang_ThucTe).AddDays(Ngay_ThucTe);
            //txtNgayHieuLuc_DenNgay.Text = NgayKetThuc_ThucTe.ToString("dd/MM/yyyy", cul);
        }
        protected void txtNgayThucTe_TextChanged(object sender, EventArgs e)
        {
            //DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            ////-------------------
            //int Thang_ThucTe = (string.IsNullOrEmpty(txtThangThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtThangThucTe.Text);
            //int Ngay_ThucTe = (string.IsNullOrEmpty(txtNgayThucTe.Text.Trim())) ? 0 : Convert.ToInt16(txtNgayThucTe.Text);
            //DateTime NgayKetThuc_ThucTe = NgayHieuLuc_BD.AddMonths(Thang_ThucTe).AddDays(Ngay_ThucTe);
            //txtNgayHieuLuc_DenNgay.Text = NgayKetThuc_ThucTe.ToString("dd/MM/yyyy", cul);
        }
        protected void txtNgayHieuLuc_DenNgay_TextChanged(object sender, EventArgs e)
        {
            //DateTime NgayHieuLuc_BD = DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //DateTime NgayKetThuc_ThucTe = DateTime.Parse(this.txtNgayHieuLuc_DenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            ////-------------------
            //double songay = (NgayKetThuc_ThucTe - NgayHieuLuc_BD).TotalDays;
            //txtThangThucTe.Text = "";
            //txtNgayThucTe.Text = songay.ToString();
        }
        #endregion
        //--------------------------------------
        #region lay thông tin/luu--
        private void GetDataToUpdate(THA_UYTHAC_QUYETDINH obj)
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_BIAN oT = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
            if (oT != null)
            {
                VuAnID = (decimal)oT.VUANID;
            }
            //-----ID------
            obj.BIANID = BiAnID;
            obj.VUANID = VuAnID;

            //-------ma QD / QS/QB.---
            obj.MAQD = txtMaQD.Text;
            obj.TENQD = txtQDvaTB.Text;

            //-------toa an uy thac---
            ToaAnUyThacID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID].ToString())) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            obj.TOAANUYTHACID = ToaAnUyThacID;//Session DonViID cua nguoi dung dang login
            obj.TOAANNHANUYTHACID = (string.IsNullOrEmpty(hddToaAnUyThacID.Value)) ? 0 : Convert.ToDecimal(hddToaAnUyThacID.Value);

            //------SoQD/Ngay raQD---
            obj.SOQD = txtSoQuyDinh.Text.Trim();
            obj.NGAYQD = String.IsNullOrEmpty(txtNgayRaQD.Text.Trim()) ? (DateTime?)null : DateTime.Parse(this.txtNgayRaQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            //----------Hieu luc tu ngay---
            obj.HIEULUC_TUNGAY = (String.IsNullOrEmpty(txtHieuLuc_TuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLuc_TuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            //------thoi han theo luat dinh/Ngay ket thuc theo luat---
            //obj.THEOLUAT_SONGAYHIEULUC = String.IsNullOrEmpty(txtNgay_TheoLuat.Text.Trim()) ? 0 : Convert.ToDecimal(txtNgay_TheoLuat.Text);
            //obj.THEOLUAT_SOTHANGHIEULUC = String.IsNullOrEmpty(txtThang_TheoLuat.Text.Trim()) ? 0 : Convert.ToDecimal(txtThang_TheoLuat.Text);

            //obj.HIEULUCTHEOLUAT_DENNGAY = String.IsNullOrEmpty(txtKetThucTheoLuat.Text.Trim()) ? (DateTime?)null : DateTime.Parse(this.txtKetThucTheoLuat.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            ////------Thời hạn thực tế/Ngay hieu luc day--- 
            //obj.THUCTE_SONGAYHIEULUC = String.IsNullOrEmpty(txtNgayThucTe.Text.Trim()) ? 0 : Convert.ToDecimal(txtNgayThucTe.Text);
            //obj.THUCTE_SOTHANGHIEULUC = String.IsNullOrEmpty(txtThangThucTe.Text.Trim()) ? 0 : Convert.ToDecimal(txtThangThucTe.Text);

            //obj.HIEULUC_DENNGAY = (String.IsNullOrEmpty(txtNgayHieuLuc_DenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayHieuLuc_DenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            //---------Nguoi ki------
            obj.NGUOIKY = ddlNguoiki.SelectedValue + "";
            obj.CHUCVU = txtChucVu.Text;
            //---------Ghi chú-----------
            obj.GHICHU = txtGhichu.Text;
        }


        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            Decimal CurrID = (String.IsNullOrEmpty(hddcurID.Value)) ? 0 : Convert.ToDecimal(hddcurID.Value);
            Boolean IsUpdate = false;
            THA_UYTHAC_QUYETDINH obj = null;
            if (CurrID > 0)
            {
                obj = dt.THA_UYTHAC_QUYETDINH.Where(x => x.ID == CurrID).FirstOrDefault();
                if (obj != null)
                    IsUpdate = true;
            }
            else
            {
                obj = new THA_UYTHAC_QUYETDINH();
            }
            if (!IsUpdate)
            {
                decimal toaNhanUyThac = (string.IsNullOrEmpty(hddToaAnUyThacID.Value)) ? 0 : Convert.ToDecimal(hddToaAnUyThacID.Value);

                List<THA_UYTHAC_QUYETDINH> tHA_UYTHAC_QUYETDINHs = dt.THA_UYTHAC_QUYETDINH.Where(x => x.BIANID == BiAnID).ToList();

                List<THA_UYTHAC_DETAIL> thaUyThacDetails = dt.THA_UYTHAC_DETAIL.Where(x => x.BIANID == BiAnID && (x.TRANGTHAI == 1 || x.TRANGTHAI == 2) ).ToList();

                List<THA_UYTHAC_DETAIL> thaUyThacDetailTraLais = dt.THA_UYTHAC_DETAIL.Where(x => x.BIANID == BiAnID && x.TRANGTHAI == 3).ToList();

                Dictionary<decimal?, THA_UYTHAC_DETAIL> dictTHADetail = thaUyThacDetails.ToDictionary(x => x.QD_UYTHACTHA_ID, x => x);


                if (tHA_UYTHAC_QUYETDINHs.Count > 0)
                {
                    if ((thaUyThacDetails.Count == 0 && thaUyThacDetailTraLais.Count == 0) || (tHA_UYTHAC_QUYETDINHs.Count > thaUyThacDetailTraLais.Count))
                    {
                        lbthongbao.Text = "Không thể thêm nhiều quyết định ủy thác!";
                        return;
                    }
                }

                foreach (THA_UYTHAC_QUYETDINH tuq in tHA_UYTHAC_QUYETDINHs)
                {
                    if (toaNhanUyThac == tuq.TOAANNHANUYTHACID)
                    {
                        lbthongbao.Text = "Không thể thêm nhiều quyết định ủy thác cho cùng tòa án!";
                        return;
                    }
                }

                if (thaUyThacDetails != null && thaUyThacDetails.Count > 0)
                {
                    lbthongbao.Text = "Bị án đang có ủy thác thi hành án khác!";
                    return;
                }
            }
            GetDataToUpdate(obj);
            if (!IsUpdate)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGAYKY = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.THA_UYTHAC_QUYETDINH.Add(obj);
            }
            dt.SaveChanges();
            LoadGrid();
            ResertControll();
            lbthongbao.Text = "Lưu thành công!";
        }

        #endregion

        #region danh sach 
        public void LoadGrid()
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_UYTHAC_QUYETDINH_BL oT = new THA_UYTHAC_QUYETDINH_BL();
            DataTable tbl = oT.GetAllByBiAnID(BiAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();
                checkTrangThaiUyThac();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }

        }
        public void checkTrangThaiUyThac()
        {
            //foreach (RepeaterItem Item in rpt.Items)
            //{
            //    LinkButton lblSua = (LinkButton)Item.FindControl("lbtSua");
            //    LinkButton lbtXoa = (LinkButton)Item.FindControl("lbtXoa");
            //    HiddenField trangthai = (HiddenField)Item.FindControl("TRANGTHAI");

            //    if (trangthai.Value.Equals("0"))
            //    {
            //        lblSua.Visible = true;
            //        lbtXoa.Visible = true;

            //    }
            //    else
            //    {
            //        lblSua.Visible = false;
            //        lbtXoa.Visible = false;
            //    }
            //}
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    loadEdit(ID);
                    hddcurID.Value = e.CommandArgument.ToString();
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

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lbtSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                HiddenField trangthai = (HiddenField)e.Item.FindControl("TRANGTHAI");

                if (trangthai.Value.Equals("0"))
                {
                    lblSua.Visible = true;
                    lbtXoa.Visible = true;

                }
                else
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }
                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                    Cls_Comon.SetButton(cmdUpdate, false);
                }
            }
        }

        private void loadEdit(decimal ID)
        {
            hddcurID.Value = ID.ToString();
            THA_UYTHAC_QUYETDINH oGA = dt.THA_UYTHAC_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            if (oGA != null)
            {
                //--------Ma va QD---------
                txtMaQD.Text = oGA.MAQD;
                txtQDvaTB.Text = oGA.TENQD;
                try
                {
                    ddlNguoiki.SelectedValue = oGA.NGUOIKY + "";
                }
                catch (Exception ex) { }
                txtChucVu.Text = oGA.CHUCVU;
                //--------ToaAn----------
                try
                {
                    Decimal toaanID = (Decimal)oGA.TOAANNHANUYTHACID;
                    txtToaAnUyThac.Text = dt.DM_TOAAN.Where(x => x.ID == toaanID).SingleOrDefault().MA_TEN;
                    hddToaAnID.Value = toaanID.ToString();

                    Decimal toaanuythacID = (Decimal)oGA.TOAANUYTHACID;
                    hddToaAnUyThacID.Value = toaanuythacID.ToString();
                    DM_TOAAN objtoaan = dt.DM_TOAAN.Where(x => x.ID == ToaAnUyThacID).FirstOrDefault();
                    if (objtoaan != null) txtUy_thac.Text = objtoaan.TEN.ToString();
                }
                catch (Exception ext) { }

                //------SoQD/Ngay raQD---
                txtSoQuyDinh.Text = oGA.SOQD;
                txtNgayRaQD.Text = String.IsNullOrEmpty(oGA.NGAYQD + "") ? "" : ((DateTime)oGA.NGAYQD).ToString("dd/MM/yyyy", cul);

                //----------Hieu luc tu ngay---
                txtHieuLuc_TuNgay.Text = String.IsNullOrEmpty(oGA.HIEULUC_TUNGAY + "") ? "" : ((DateTime)oGA.HIEULUC_TUNGAY).ToString("dd/MM/yyyy", cul);

                //------thoi han theo luat dinh/Ngay ket thuc theo luat---
                //txtKetThucTheoLuat.Text = string.IsNullOrEmpty(oGA.HIEULUCTHEOLUAT_DENNGAY + "") ? "" : ((DateTime)oGA.HIEULUCTHEOLUAT_DENNGAY).ToString("dd/MM/yyyy", cul);
                //txtNgay_TheoLuat.Text = (String.IsNullOrEmpty(oGA.THEOLUAT_SONGAYHIEULUC + "") || (oGA.THEOLUAT_SONGAYHIEULUC == 0)) ? "" : oGA.THEOLUAT_SONGAYHIEULUC + "";
                //txtThang_TheoLuat.Text = (String.IsNullOrEmpty(oGA.THEOLUAT_SOTHANGHIEULUC + "") || (oGA.THEOLUAT_SOTHANGHIEULUC == 0)) ? "" : oGA.THEOLUAT_SOTHANGHIEULUC + "";

                ////------Thời hạn thực tế/Ngay hieu luc day---          
                //txtNgayThucTe.Text = (String.IsNullOrEmpty(oGA.THUCTE_SONGAYHIEULUC+"") ||(oGA.THUCTE_SONGAYHIEULUC==0)) ? "" : oGA.THUCTE_SONGAYHIEULUC + "";
                //txtThangThucTe.Text = (String.IsNullOrEmpty(oGA.THUCTE_SOTHANGHIEULUC + "") || (oGA.THUCTE_SOTHANGHIEULUC == 0)) ? "" : oGA.THUCTE_SOTHANGHIEULUC + "";
                //txtNgayHieuLuc_DenNgay.Text = String.IsNullOrEmpty(oGA.HIEULUC_DENNGAY + "") ? "" : ((DateTime)oGA.HIEULUC_DENNGAY).ToString("dd/MM/yyyy", cul);

                //---------Ghi chú-----------
                txtGhichu.Text = oGA.GHICHU;
            }
        }
        private void xoa(decimal ID)
        {
            THA_UYTHAC_QUYETDINH oGA = dt.THA_UYTHAC_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            if (oGA != null)
            {
                dt.THA_UYTHAC_QUYETDINH.Remove(oGA);
                dt.SaveChanges();
                ResertControll();
                LoadGrid();
                lbthongbao.Text = "Xóa thành công!";
            }
        }
        #endregion
    }
}