using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.XLHC.KCKN;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.XLHC.Thamphan
{
    public partial class GiaiquyetPhucthamKCKN : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    LoadCombobox();
                    LoadDataThuKy();

                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);

                    decimal DONID = Convert.ToDecimal(current_id);
                    CheckQuyen(DONID);
                    LoadGrid();
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }
            
        }

        void CheckQuyen(decimal DONID)
        {
            decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                .FirstOrDefault();
            if (chuyenNhanAn != null)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }

            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }

            XLHC_PHUCTHAM_BL oBL = new XLHC_PHUCTHAM_BL();
            DataTable oDT = oBL.XLHC_KCKNQDK_PHUCTHAM_HDXX_GETLIST(DONID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                bool exists = false;

                foreach (DataRow row in oDT.Rows)
                {
                    if (row["TOA_GIAIQUYET_ID"].ToString() == TOAANID.ToString())
                    {
                        exists = true;
                        break;
                    }
                }
                if (exists)
                {
                    lbthongbao.Text = "Đã có người tiến hành tố tụng, Không được sửa đổi !";
                    hddShowDetail.Value = "False";
                    return;
                }
                
            }

            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
            List<XLHC_KCKNQDK_PHUCTHAM_THULY> lstCount = DataExtensions.GetAllByDonId<XLHC_KCKNQDK_PHUCTHAM_THULY>(DONID);
            if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                return;
            }
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }

            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
        }
        private void LoadDataThuKy()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY);
            if (oCBDT != null)
            {
                if (oCBDT.Rows.Count > 0)
                {
                    ddlThuky.DataSource = oCBDT;
                    ddlThuky.DataTextField = "HOTEN";
                    ddlThuky.DataValueField = "ID";
                    ddlThuky.DataBind();
                    ddlThuky.Items.Insert(0, new ListItem("--Chọn thư ký--", "0"));
                    GetDataDefaultThuKy();
                }
                else
                {
                    ddlThuky.Items.Insert(0, new ListItem("--Chọn thư ký--", "0"));
                }
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                //decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                //XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                //    .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                //    .FirstOrDefault();
                //if (chuyenNhanAn != null)
                //{
                //    // DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == TOAANID).FirstOrDefault<DM_TOAAN>();
                //    // lstErr.Text = "Án đã chuyển đến " + oTA.TEN + ". Không thể cập nhật!";
                //    lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                //    // lblSua.Visible = false;
                //    lbtXoa.Visible = false;
                //}

                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lbthongbao.Text = Result;
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddIsShowCommand.Value = "false";
                }

                if (!Convert.ToBoolean(hddIsShowCommand.Value))
                {
                    lblSua.Visible = lbtXoa.Visible = false;
                }

                if (!Convert.ToBoolean(hddShowDetail.Value))
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                string toagiaiquyetID = e.Item.Cells[9].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }
            }
        }
        private void GetDataDefaultThuKy()
        {
            decimal value = decimal.Parse(ddlThamphan.SelectedValue);
            var obj = dt.CAUHINH_THAMPHAN_THUKY.FirstOrDefault(s => s.THAMPHAMID == value);
            if (obj != null)
            {

                ddlThuky.SelectedValue = obj.THUKYID.Value.ToString();

            }
            else
            {
                ddlThuky.SelectedValue = "0";
            }
        }
        protected void myListDropDown_Change(object sender, EventArgs e)
        {

            GetDataDefaultThuKy();
        }
        private void LoadCombobox()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphan.DataSource = oCBDT;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
            ddlThamphan.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));
            ddlNguoiphancong.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            ddlNguoiphancong.DataTextField = "MA_TEN";
            ddlNguoiphancong.DataValueField = "ID";
            ddlNguoiphancong.DataBind();
            //ddlNguoiphancong.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));

            //Load quốc tịch
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dtVaiTro = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.VAITROTHAMPHAN);

            ddlVaitro.DataSource = dtVaiTro;
            ddlVaitro.DataTextField = "TEN";
            ddlVaitro.DataValueField = "MA";
            ddlVaitro.DataBind();
            ddlVaitro.SelectedValue = ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM;
            ddlVaitro.Enabled = false;
        }
        private void ResetControls()
        {
            ddlThamphan.SelectedIndex = 0;
            txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            txtNgayketthuc.Text = "";
            hddid.Value = "0";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
        }
        private bool CheckValid()
        {
            if (ddlThamphan.SelectedIndex == 0)
            {
                lbthongbao.Text = "Chưa chọn thẩm phán !";
                return false;
            }

            if (ddlVaitro.Items.Count == 0)
            {
                lbthongbao.Text = "Chưa chọn vai trò thẩm phán !";
                return false;
            }
            if (txtNgayphancong.Text == "")
            {
                lbthongbao.Text = "Chưa nhập ngày phân công !";
                return false;
            }
            if (txtNhanphancong.Text == "")
            {
                lbthongbao.Text = "Chưa nhập ngày nhận phân công !";
                return false;
            }
            if (ddlNguoiphancong.Items.Count == 0)
            {
                lbthongbao.Text = "Chưa chọn người phân công !";
                return false;
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "", MaVaiTro = ddlVaitro.SelectedValue;
                decimal DONID = Convert.ToDecimal(current_id), CanBoID = Convert.ToDecimal(ddlThamphan.SelectedValue);

                XLHC_DON_THAMPHAN oND;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    // Kiểm tra nếu thẩm phán đã được phân công rồi thì không phân lại nữa. Chọn thẩm phán khác
                    oND = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == DONID && x.CANBOID == CanBoID && x.MAVAITRO == MaVaiTro).FirstOrDefault();
                    if (oND != null)
                    {
                        lbthongbao.Text = "Thẩm phán " + ddlThamphan.SelectedItem.Text + " đã được phân công. Hãy chọn lại!";
                        ddlThamphan.Focus();
                        return;
                    }
                    oND = new XLHC_DON_THAMPHAN();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.XLHC_DON_THAMPHAN.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                oND.CANBOID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                oND.THUKYID = Convert.ToDecimal(ddlThuky.SelectedValue);
                oND.MAVAITRO = ddlVaitro.SelectedValue;
                oND.NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiphancong.SelectedValue);

                DateTime dNgayPhanCong = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYPHANCONG = dNgayPhanCong;

                DateTime dNgayNhanPhanCong = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYNHANPHANCONG = dNgayNhanPhanCong;


                DateTime dNgayKetthuc = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYKETTHUC = dNgayKetthuc == DateTime.MinValue ? (DateTime?)null : dNgayKetthuc;

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.XLHC_DON_THAMPHAN.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                lbthongbao.Text = "Lưu thành công!";
                dgList.CurrentPageIndex = 0;
                CheckQuyen(DONID);
                LoadGrid();
                ResetControls();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;

            }
        }
        public void LoadGrid()
        {
            XLHC_DON_THAMPHAN_BL oBL = new XLHC_DON_THAMPHAN_BL();
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.XLHC_DON_THAMPHAN_GETBY(ID, ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                pndata.Visible = false;
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }
        public void xoa(decimal id)
        {
            XLHC_DON_THAMPHAN oND = dt.XLHC_DON_THAMPHAN.Where(x => x.ID == id).FirstOrDefault();
            dt.XLHC_DON_THAMPHAN.Remove(oND);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID, decimal DONID)
        {
            XLHC_DON_THAMPHAN oND = dt.XLHC_DON_THAMPHAN.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            if (ddlThamphan.Items.FindByValue(oND.CANBOID + "") != null)
                ddlThamphan.SelectedValue = oND.CANBOID + "";
            if (ddlThuky.Items.FindByValue(oND.THUKYID + "") != null)
                ddlThuky.SelectedValue = oND.THUKYID + "";
            else
                ddlThuky.SelectedValue = 0 + "";
            ddlVaitro.SelectedValue = oND.MAVAITRO;

            txtNgayphancong.Text = (oND.NGAYPHANCONG == DateTime.MinValue || oND.NGAYPHANCONG + "" == "") ? "" : ((DateTime)oND.NGAYPHANCONG).ToString("dd/MM/yyyy", cul);
            txtNhanphancong.Text = (oND.NGAYNHANPHANCONG == DateTime.MinValue || oND.NGAYNHANPHANCONG + "" == "") ? "" : ((DateTime)oND.NGAYNHANPHANCONG).ToString("dd/MM/yyyy", cul);
            txtNgayketthuc.Text = (oND.NGAYKETTHUC == DateTime.MinValue || oND.NGAYKETTHUC + "" == "") ? "" : ((DateTime)oND.NGAYKETTHUC).ToString("dd/MM/yyyy", cul);
            if (ddlNguoiphancong.Items.FindByValue(oND.NGUOIPHANCONGID + "") != null)
                ddlNguoiphancong.SelectedValue = oND.NGUOIPHANCONGID + "";

            XLHC_PHUCTHAM_BL oBL = new XLHC_PHUCTHAM_BL();
            DataTable oDT = oBL.XLHC_KCKNQDK_PHUCTHAM_HDXX_GETLIST(DONID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                //Cls_Comon.SetButton(cmdUpdate, false);
                //--VNPT - Đinh Hoàng Sơn -chỉnh check quyền sửa -18 - 9 - 2025 08:00
                foreach (DataRow item in oDT.Rows)
                {
                    if (item["TOA_GIAIQUYET_ID"].ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                    {
                        Cls_Comon.SetButton(cmdUpdate, false);
                    }
                }

            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            string[] arr = e.CommandArgument.ToString().Split('#');
            decimal ND_id = Convert.ToDecimal(arr[0]),
                    TPID = Convert.ToDecimal(arr[1]);
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    CheckQuyen(DonID);
                    loadedit(ND_id, DonID);
                    hddid.Value = ND_id + "";
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    if (!CheckQDofThamPhan(DonID, TPID))
                    {
                        lbthongbao.Text = "Thẩm phán đã có quyết định liên quan, không được xóa. Hãy xem lại!";
                        return;
                    }
                    xoa(ND_id);
                    ResetControls();
                    break;
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }
        #endregion
        protected void txtNgayphancong_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNgayphancong.Text.Trim()))
            {
                txtNhanphancong.Text = txtNgayphancong.Text;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayketthuc.ClientID);
            }
        }
        protected void txtNhanphancong_TextChanged(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(txtNgayphancong.Text))
            {
                txtNhanphancong.Text = txtNgayphancong.Text;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayketthuc.ClientID);
            }
        }
        private bool CheckQDofThamPhan(decimal DonID, decimal TPID)
        {
            var donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            // kiểm tra các quyết định mà thẩm phán đã ký trong vụ việc (nếu có)
            XLHC_PHUCTHAM_QUYETDINH obj_QD = dt.XLHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == DonID && x.NGUOIKYID == TPID && x.TOA_GIAIQUYET_ID == donviID).FirstOrDefault<XLHC_PHUCTHAM_QUYETDINH>();
            if (obj_QD != null)
            {
                lbthongbao.Text = "Thẩm phán đã ký quyết định của vụ việc. Không được xóa!";
                return false;
            }
            return true;
        }
    }
}