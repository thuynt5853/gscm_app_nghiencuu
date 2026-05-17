using BL.GSTP;
using BL.GSTP.AHC;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.AHC;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHC.Thamphan
{
    public partial class GiaiquyetPhucthamKCKNQDK : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
                if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHC/Hoso/Danhsach.aspx");
                decimal DONID = Convert.ToDecimal(current_id);
                LoadCombobox();
                LoadDataThuKy();
             
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);
                //Kiểm tra thẩm phán giải quyết đơn 
                checkQuyen(DONID);
                LoadGrid();


            }
        }



        void checkQuyen(decimal DONID)
        {

            AHC_KCKN_PHUCTHAM_BL oBL = new AHC_KCKN_PHUCTHAM_BL();
            DataTable oDT = oBL.AHC_PHUCTHAM_KCKN_TGTT_GETLIST(DONID);
            var currenttoaid = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                bool exists = false;

                foreach (DataRow row in oDT.Rows)
                {
                    if (row["TOA_GIAIQUYET_ID"].ToString() == currenttoaid.ToString())
                    {
                        exists = true;
                        break;
                    }
                }
                if (exists)
                {
                    lbthongbao.Text = "Đã có người tham gia tố tụng, Không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowDetail.Value = "False";
                    return;
                }
            }

            AHC_KCKN_PHUCTHAM_BL BL = new AHC_KCKN_PHUCTHAM_BL();
            DataTable DT = BL.AHC_KCKNQDK_PHUCTHAM_HDXX_GETLIST(DONID);
            if (DT != null && DT.Rows.Count > 0 && DT.AsEnumerable()
               .Any(row => row["TOA_GIAIQUYET_ID"].ToString() == currenttoaid.ToString()))
            {
                lbthongbao.Text = "Đã có người tiến hành tố tụng, Không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowDetail.Value = "False";
                return;
            }
            AHC_DON oT = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
            //List<AHC_KCKNQDK_PHUCTHAM_THULY> lstCount = dt.AHC_KCKNQDK_PHUCTHAM_THULY.Where(x => x.DONID == DONID).ToList();
            List<AHC_KCKNQDK_PHUCTHAM_THULY> lstCount = DataExtensions.GetAllWithClause<AHC_KCKNQDK_PHUCTHAM_THULY>("DONID = " + DONID);
            if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                return;
            }
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                return;
            }
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                return;
            }
            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                return;
            }
        }
        private void LoadDataThuKy()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            //DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY);
            // Lay Thu ky và TTV
            DataTable oCBDT = oDMCBBL.DM_CANBO_GetAllThuKy_TTV(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), "");
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
                string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHC_DON oT = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                decimal donvi_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]?.ToString());
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
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

                string toagiaiquyetID = rowView["TOA_GIAIQUYET_ID"].ToString();
                if (!toagiaiquyetID.Equals(donviID))
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }
            }
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
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "", MaVaiTro = ddlVaitro.SelectedValue;
                decimal DONID = Convert.ToDecimal(current_id), CanBoID = Convert.ToDecimal(ddlThamphan.SelectedValue);

                var currenttoaid = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                AHC_DON_THAMPHAN oND;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    // Kiểm tra nếu thẩm phán đã được phân công rồi thì không phân lại nữa. Chọn thẩm phán khác
                    oND = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == DONID && x.CANBOID == CanBoID && x.MAVAITRO == MaVaiTro && x.TOA_GIAIQUYET_ID == currenttoaid).FirstOrDefault();
                    if (oND != null)
                    {
                        lbthongbao.Text = "Thẩm phán " + ddlThamphan.SelectedItem.Text + " đã được phân công. Hãy chọn lại!";
                        ddlThamphan.Focus();
                        return;
                    }
                    oND = new AHC_DON_THAMPHAN();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.AHC_DON_THAMPHAN.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                oND.CANBOID = CanBoID;
                oND.THUKYID = Convert.ToDecimal(ddlThuky.SelectedValue);
                oND.MAVAITRO = MaVaiTro;
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
                    dt.AHC_DON_THAMPHAN.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }

                //toancau-linhnd-insert phân công thẩm phán vào người tiến hành tố tụng
                AHC_KCKNQDK_PHUCTHAM_HDXX oTHTT = DataExtensions.GetAllWithClause<AHC_KCKNQDK_PHUCTHAM_HDXX>($"DONID = {DONID} AND MAVAITRO = '{ENUM_NGUOITIENHANHTOTUNG.THAMPHAN}'").FirstOrDefault();
                decimal toaGiaiQuyet = 0;
                if (oTHTT != null)
                    toaGiaiQuyet = Convert.ToDecimal(oTHTT.TOA_GIAIQUYET_ID);
                if (oTHTT == null || toaGiaiQuyet != Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]))
                {
                    oTHTT = new AHC_KCKNQDK_PHUCTHAM_HDXX();
                    oTHTT.DONID = DONID;
                    oTHTT.CANBOID = CanBoID;
                    oTHTT.MAVAITRO = ENUM_NGUOITIENHANHTOTUNG.THAMPHAN;
                    oTHTT.NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiphancong.SelectedValue);
                    oTHTT.NGAYPHANCONG = dNgayPhanCong;
                    oTHTT.NGAYNHANPHANCONG = dNgayNhanPhanCong;
                    oTHTT.NGAYTAO = DateTime.Now;
                    oTHTT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    //update 13082025
                    if (oTHTT.TOA_GIAIQUYET_ID == null) oTHTT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    DataExtensions.Insert(oTHTT);
                }

                lbthongbao.Text = "Lưu thành công!";
                dgList.CurrentPageIndex = 0;
                checkQuyen(DONID);
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
            AHC_DON_THAMPHAN_BL oBL = new AHC_DON_THAMPHAN_BL();
            string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.AHC_DON_THAMPHAN_GETBY(ID, ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM);

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
            AHC_DON_THAMPHAN oND = dt.AHC_DON_THAMPHAN.Where(x => x.ID == id).FirstOrDefault();
            //Luu thong tin Thẩm phán giải quyết Phúc thẩm trước khi xoa
            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            var json = new JavaScriptSerializer().Serialize(oND);
            ADS_DON_BL oBL = new ADS_DON_BL();
            if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.DONID), 6, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Thẩm phán giải quyết Phúc thẩm an Hanh chính", "Xóa", json) == false)
            {
                lbthongbao.Text = "Xóa không thành công!";
                return;
            }//Ket thuc

            //Xoa tham phan giải quyết án Phúc thẩm
            dt.AHC_DON_THAMPHAN.Remove(oND);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            AHC_DON_THAMPHAN oND = dt.AHC_DON_THAMPHAN.Where(x => x.ID == ID).FirstOrDefault();
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
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            string[] arr = e.CommandArgument.ToString().Split('#');
            decimal ND_id = Convert.ToDecimal(arr[0]),
                    TPID = Convert.ToDecimal(arr[1]);
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = ND_id + "";
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH] + "");
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
            // kiểm tra các quyết định mà thẩm phán đã ký trong vụ việc (nếu có)
            //AHC_PHUCTHAM_QUYETDINH obj_QD = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == DonID && x.NGUOIKYID == TPID).FirstOrDefault<AHC_PHUCTHAM_QUYETDINH>();
            AHC_KCKNQDK_PHUCTHAM_QUYETDINH obj_QD = DataExtensions.GetAllWithClause<AHC_KCKNQDK_PHUCTHAM_QUYETDINH>("DONID = " + DonID + "and NGUOIKYID = " + TPID).FirstOrDefault<AHC_KCKNQDK_PHUCTHAM_QUYETDINH>();
            if (obj_QD != null)
            {
                lbthongbao.Text = "Thẩm phán đã ký quyết định của vụ việc. Không được xóa!";
                return false;
            }
            return true;
        }
    }
}