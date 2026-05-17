using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.HOAGIAI;
using BL.GSTP.HOAGIAI;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.HOAGIAI
{
    public partial class GiaoNhanDon : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private HOAGIAI_BL _hoaGiaiBl = new HOAGIAI_BL();
        private static CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal loaiAn = 0;
        public Decimal vuViecId = 0;
        public string hoagiaitext = "hoà giải";

        protected void Page_Load(object sender, EventArgs e)
        {
            lblThongBao.Text = "";
            string strMaCT = Session["MaChuongTrinh"] + "";
            string returnURL = "";
            switch (strMaCT)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_DANSU.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU].ToString());
                    break;

                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH].ToString());
                    break;

                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/AKT/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI].ToString());
                    break;

                case ENUM_LOAIAN.AN_LAODONG:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/ALD/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG].ToString());
                    break;

                case ENUM_LOAIAN.AN_HANHCHINH:
                    loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH.toNumber();
                    returnURL = Cls_Comon.GetRootURL() + "/QLAN/AHC/Hoso/Danhsach.aspx";
                    vuViecId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH].ToString());
                    hoagiaitext = "đối thoại";
                    break;

                default:
                    returnURL = "/Trangchu.aspx";
                    break;
            }

            if (vuViecId == 0) Response.Redirect(returnURL);
            hddLoaiAn.Value = loaiAn.ToString();
            hddVuViecId.Value = vuViecId.ToString();
            var hoaGiaiDon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {vuViecId} AND LOAIANID = {loaiAn}").FirstOrDefault();
            if (hoaGiaiDon != null)
                hddHoaGiaiId.Value = hoaGiaiDon.ID.ToString();
            else
                Response.Redirect(returnURL);
            if (!IsPostBack)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
                Cls_Comon.SetButton(btnLammoi, oPer.CAPNHAT);
                checkQuyen();
                this.InitDrop();
                LoadGrid();
            }
        }
        private void InitDrop()
        {
            DM_CANBO_BL dmCBBL = new DM_CANBO_BL();
            DataTable dsNguoiGiao = dmCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            var lstCanBo = (from rw in dsNguoiGiao.AsEnumerable()
                            select new ListItem(rw["MA_TEN"].ToString(), rw["ID"].ToString())).ToList();
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable dsHGV = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_HGV);
            var lstHGV = (from rw in dsHGV.AsEnumerable()
                          select new ListItem(rw["MA_TEN"].ToString(), rw["ID"].ToString())).ToList();

            var lstNguoiGiao = lstCanBo.Where(i => !lstHGV.Any(e => e.Value.Equals(i.Value))).ToList();
            LoadDropNguoiBanGiao(lstNguoiGiao);
            LoadDropNguoiNhan(lstHGV);
        }
        public void checkQuyen()
        {
            loaiAn = Convert.ToDecimal(hddLoaiAn.Value);
            vuViecId = Convert.ToDecimal(hddVuViecId.Value);

            var checkPCTPQGD = _hoaGiaiBl.CheckPCTPQGD(vuViecId, loaiAn);
            if (checkPCTPQGD)
            {
                Cls_Comon.SetButton(btnUpdate, true);
            }
            else
            {
                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc đã được phân công thẩm phán giải quyết đơn. Không được sửa!";
                return;
            }
            var checkThuLy = _hoaGiaiBl.CheckThuLy(vuViecId, loaiAn);
            if (checkThuLy)
            {
                btnUpdate.Visible = true;
            }
            else
            {
                btnUpdate.Visible = false;
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc đã được thụ lý. Không được sửa!";
                return;
            }
            var hoaGiaiDon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {vuViecId} AND LOAIANID = {loaiAn}").FirstOrDefault();
            var pctp = DataExtensions.GetAllWithClause<HOAGIAI_THAMPHAN>($"HOAGIAIID = {hoaGiaiDon.ID}").FirstOrDefault();
            if (pctp != null)
            {
                btnUpdate.Visible = false;
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc đã được phân công. Không được sửa!";
                return;
            }
        }

        public void LoadGrid()
        {
            try
            {
                DataTable oDT = _hoaGiaiBl.GETLIST_GIAONHANDON(Convert.ToDecimal(hddHoaGiaiId.Value), Convert.ToDecimal(hddLoaiAn.Value));
                if (oDT != null && oDT.Rows.Count > 0)
                {
                    dgList.DataSource = oDT;
                    dgList.DataBind();
                }
                else
                {
                    dgList.DataSource = oDT;
                    dgList.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblThongBao.Text = ex.Message;
            }
        }
        private void LoadDropNguoiBanGiao(List<ListItem> lst)
        {
            ddlNguoiGiao.Items.Clear();
            lst.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlNguoiGiao.DataSource = lst;
            ddlNguoiGiao.DataValueField = "Value";
            ddlNguoiGiao.DataTextField = "Text";
            ddlNguoiGiao.DataBind();
            try
            {
                string strCBID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
                if (strCBID != "") ddlNguoiGiao.SelectedValue = strCBID;
            }
            catch { }
        }

        private void LoadDropNguoiNhan(List<ListItem> lst)
        {
            ddlNguoiNhan.DataSource = lst;
            ddlNguoiNhan.DataValueField = "Value";
            ddlNguoiNhan.DataTextField = "Text";
            ddlNguoiNhan.DataBind();
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
                string current_id = ND_id.ToString();
                decimal APID = Convert.ToDecimal(current_id);
                switch (e.CommandName)
                {
                    case "Sua":
                        lblThongBao.Text = "";
                        LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                        if (lblSua.Text == "Sửa")
                        {
                            Cls_Comon.SetButton(btnUpdate, true);
                        }
                        else
                        {
                            Cls_Comon.SetButton(btnUpdate, false);
                        }
                        loadedit(ND_id);
                        hddid.Value = e.CommandArgument.ToString();
                        break;

                    case "Xoa":
                        try
                        {
                            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                            if (oPer.XOA == false || btnUpdate.Enabled == false)
                            {
                                lblThongBao.Text = "Bạn không có quyền xóa!";
                                return;
                            }
                            //var item = DataExtensions.FindById<HOAGIAI_DON_GIAONHAN>(ND_id);
                            //DataExtensions.Delete(item);
                            //lblThongBao.Text = "Xóa thành công!";
                            //this.LoadGrid();
                            //ResetControls();
                            bool result = DataExtensions.Delete<HOAGIAI_DON_GIAONHAN>(new HOAGIAI_DON_GIAONHAN() { ID = APID });
                            if (result)
                            {
                                lblThongBao.Text = "Xóa thành công!";
                                this.LoadGrid();
                            }
                            else
                            {
                                lblThongBao.Text = "Không thể xóa hãy thử lại";
                            }

                        }
                        catch (Exception ex)
                        {
                            lblThongBao.Text = ex.Message;
                        }
                        break;
                }
            }
            catch (Exception ex)
            {
                lblThongBao.Text = ex.Message;
            }
        }

        public void loadedit(decimal id)
        {
            HOAGIAI_DON_GIAONHAN item = DataExtensions.FindById<HOAGIAI_DON_GIAONHAN>(id);
            if (item != null)
            {
                hddid.Value = id.ToString();

                txtGhiChu.Text = item.GHICHU + "";
                if (item.NGAYGIAO != null) txtNgayGiao.Text = ((DateTime)item.NGAYGIAO).ToString("dd/MM/yyyy", cul);
                //if (item.NGAYGIAOTHUC != null) txtNgayGiaoThuc.Text = ((DateTime)item.NGAYGIAOTHUC).ToString("dd/MM/yyyy", cul);
                if (item.NGAYLAP != null) txtNgayLapBienBan.Text = ((DateTime)item.NGAYLAP).ToString("dd/MM/yyyy", cul);
                if (item.NGAYNHAN != null) txtNgayNhan.Text = ((DateTime)item.NGAYNHAN).ToString("dd/MM/yyyy", cul);

                ddlNguoiGiao.SelectedValue = item.NGUOIGIAOID.ToString();
                ddlNguoiNhan.SelectedValue = item.NGUOINHANID.ToString();
                ddlTrangThai.SelectedValue = item.TRANGTHAI.ToString();
            }
        }

        protected void dgList_ItemDataBound(object source, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                loaiAn = Convert.ToDecimal(hddLoaiAn.Value);
                vuViecId = Convert.ToDecimal(hddVuViecId.Value);
                var checkPCTPQGD = _hoaGiaiBl.CheckPCTPQGD(this.vuViecId, this.loaiAn);
                if (checkPCTPQGD)
                {
                    lblSua.Visible = lbtXoa.Visible = true;
                    Cls_Comon.SetButton(btnUpdate, true);
                    lblSua.Text = "Sửa";
                }
                else
                {
                    lbtXoa.Visible = false;
                    lblSua.Text = "Chi tiết";
                    Cls_Comon.SetButton(btnUpdate, false);
                }
                var checkThuLy = _hoaGiaiBl.CheckThuLy(vuViecId, loaiAn);
                if (checkThuLy)
                {
                    lblSua.Visible = lbtXoa.Visible = true;
                    Cls_Comon.SetButton(btnUpdate, true);
                    lblSua.Text = "Sửa";
                }
                else
                {
                    lbtXoa.Visible = false;
                    lblSua.Text = "Chi tiết";
                    Cls_Comon.SetButton(btnUpdate, false);
                }
                if (!Convert.ToBoolean(hddShowCommand.Value))
                {
                    lbtXoa.Visible = false;
                    lblSua.Text = "Chi tiết";
                    Cls_Comon.SetButton(btnUpdate, false);
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                else
                {
                    decimal id = Convert.ToDecimal(hddid.Value);
                    HOAGIAI_DON_GIAONHAN item;
                    if (id > 0)
                        item = DataExtensions.FindById<HOAGIAI_DON_GIAONHAN>(id);
                    else
                        item = new HOAGIAI_DON_GIAONHAN();
                    item.HOAGIAIID = Convert.ToDecimal(hddHoaGiaiId.Value);
                    item.NGUOIGIAOID = Convert.ToDecimal(ddlNguoiGiao.SelectedValue);
                    item.NGUOINHANID = Convert.ToDecimal(ddlNguoiNhan.SelectedValue);
                    item.TRANGTHAI = Convert.ToDecimal(ddlTrangThai.SelectedValue);
                    item.NGAYGIAO = (String.IsNullOrEmpty(txtNgayGiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayGiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    //item.NGAYGIAOTHUC = (String.IsNullOrEmpty(txtNgayGiaoThuc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayGiaoThuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    item.NGAYNHAN = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    item.NGAYLAP = (String.IsNullOrEmpty(txtNgayLapBienBan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayLapBienBan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    item.GHICHU = txtGhiChu.Text;
                    bool isImpact = false;
                    if (item.ID == 0)
                    {
                        item.NGAYTAO = item.NGAYSUA = DateTime.Now;
                        item.NGUOITAO = item.NGUOISUA = DateTime.Now.ToString("dd/MM/yyyy") + "\n" + Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                        decimal result = DataExtensions.Insert(item);
                        if (result > 0)
                            isImpact = true;
                    }
                    else
                    {
                        item.NGAYSUA = DateTime.Now;
                        item.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                        isImpact = DataExtensions.Update(item);
                    }
                    if (isImpact)
                    {
                        ResetControls();
                        LoadGrid();
                        lblThongBao.Text = "Lưu thành công!";
                    }
					else
					{
						lblThongBao.Text = "Có lỗi trong quá trình xử lý";
						return;
					}
				}
            }
            catch
            {
                lblThongBao.Text = "Dữ liệu không hợp lệ hãy kiểm tra và thực hiện lại";
            }
        }

        private bool CheckValid()
        {
            #region txtNgayGiao

            if (String.IsNullOrEmpty(txtNgayGiao.Text))
            {
                lblThongBao.Text = "Bạn chưa nhập ngày giao !";
                txtNgayGiao.Focus();
                return false;
            }
            else
            {
                if (Cls_Comon.IsValidDate(txtNgayGiao.Text) == false)
                {
                    lblThongBao.Text = "Bạn chưa nhập ngày giao theo định dạng (dd/MM/yyyy) !";
                    txtNgayGiao.Focus();
                    return false;
                }

                DateTime NgayGiao = DateTime.Parse(txtNgayGiao.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                if (NgayGiao > DateTime.Now)
                {
                    lblThongBao.Text = "Ngày giao phải trước ngày hiện tại !";
                    txtNgayGiao.Focus();
                    return false;
                }
                if (String.IsNullOrEmpty(txtNgayNhan.Text))
                {
                    if (Cls_Comon.IsValidDate(txtNgayGiao.Text))
                    {
                        DateTime NgayNhan = DateTime.Parse(txtNgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        if (NgayGiao > NgayNhan)
                        {
                            lblThongBao.Text = "Ngày giao trước ngày nhận " + txtNgayNhan.Text + " !";
                            txtNgayGiao.Focus();
                            return false;
                        }
                    }
                }
            }

            #endregion txtNgayGiao

            #region txtNgayGiaoThuc

            //if (String.IsNullOrEmpty(txtNgayGiaoThuc.Text))
            //{
            //    lblThongBao.Text = "Bạn chưa nhập ngày giao thực tế!";
            //    txtNgayGiaoThuc.Focus();
            //    return false;
            //}
            //else
            //{
            //if (Cls_Comon.IsValidDate(txtNgayGiaoThuc.Text) == false)
            //{
            //    lblThongBao.Text = "Bạn chưa nhập ngày giao thực tế theo định dạng (dd/MM/yyyy) !";
            //    txtNgayGiaoThuc.Focus();
            //    return false;
            //}

            //DateTime NgayGiao = DateTime.Parse(txtNgayGiaoThuc.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            //if (NgayGiao > DateTime.Now)
            //{
            //    lblThongBao.Text = "Ngày giao thực tế phải trước ngày hiện tại !";
            //    txtNgayGiaoThuc.Focus();
            //    return false;
            //}
            //if (String.IsNullOrEmpty(txtNgayNhan.Text))
            //{
            //if (Cls_Comon.IsValidDate(txtNgayGiaoThuc.Text))
            //{
            //    DateTime NgayNhan = DateTime.Parse(txtNgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            //    if (NgayGiao > NgayNhan)
            //    {
            //        lblThongBao.Text = "Ngày giao thực tế trước ngày nhận " + txtNgayNhan.Text + " !";
            //        txtNgayGiaoThuc.Focus();
            //        return false;
            //    }
            //}
            //}
            //}

            #endregion txtNgayGiaoThuc

            #region txtNgayNhan

            if (String.IsNullOrEmpty(txtNgayNhan.Text))
            {
                lblThongBao.Text = "Bạn chưa nhập ngày nhận !";
                txtNgayNhan.Focus();
                return false;
            }
            else
            {
                if (Cls_Comon.IsValidDate(txtNgayNhan.Text) == false)
                {
                    lblThongBao.Text = "Bạn chưa nhập ngày nhận theo định dạng (dd/MM/yyyy) !";
                    txtNgayNhan.Focus();
                    return false;
                }

                //DateTime ngayNhan = DateTime.Parse(txtNgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? ngayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                if (ngayNhan > DateTime.Now || ngayNhan == null)
                {
                    lblThongBao.Text = "Ngày nhận phải trước ngày hiện tại !";
                    txtNgayNhan.Focus();
                    return false;
                }
                //if (String.IsNullOrEmpty(txtNgayNhan.Text))
                //{
                //if (Cls_Comon.IsValidDate(txtNgayNhan.Text))
                //{
                //DateTime ngayGiaoThuc = DateTime.Parse(txtNgayGiaoThuc.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                //if (ngayNhan < ngayGiaoThuc)
                //{
                //    lblThongBao.Text = "Ngày nhận sau ngày giao thực " + txtNgayGiaoThuc.Text + " !";
                //    txtNgayNhan.Focus();
                //    return false;
                //}
                //}
                //}
            }

            #endregion txtNgayNhan

            #region txtNgayLapBienBan

            if (String.IsNullOrEmpty(txtNgayLapBienBan.Text))
            {
                lblThongBao.Text = "Bạn chưa nhập ngày lập biên bản !";
                txtNgayLapBienBan.Focus();
                return false;
            }
            else
            {
                if (Cls_Comon.IsValidDate(txtNgayLapBienBan.Text) == false)
                {
                    lblThongBao.Text = "Bạn chưa nhập ngày lập biên bản theo định dạng (dd/MM/yyyy) !";
                    txtNgayLapBienBan.Focus();
                    return false;
                }
            }

            #endregion txtNgayLapBienBan

            #region ddlNguoiGiao

            if (ddlNguoiGiao.SelectedValue == "0")
            {
                lblThongBao.Text = "Bạn chưa chọn người giao. Hãy chọn lại!";
                ddlNguoiGiao.Focus();
                return false;
            }

            #endregion ddlNguoiGiao

            #region ddlNguoiNhan

            if (ddlNguoiNhan.SelectedValue == "0")
            {
                lblThongBao.Text = "Bạn chưa chọn người nhận. Hãy chọn lại!";
                ddlNguoiNhan.Focus();
                return false;
            }

            #endregion ddlNguoiNhan

            #region ddlTrangThai

            if (ddlTrangThai.SelectedValue == "0")
            {
                lblThongBao.Text = "Bạn chưa chọn trạng thái. Hãy chọn lại!";
                ddlTrangThai.Focus();
                return false;
            }

            #endregion ddlTrangThai

            return true;
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }

        private void ResetControls()
        {
            txtNgayGiao.Text = txtNgayNhan.Text = txtNgayLapBienBan.Text = txtGhiChu.Text = "";
            ddlNguoiGiao.SelectedIndex = 0;
            ddlNguoiNhan.SelectedIndex = 0;
            ddlTrangThai.SelectedIndex = 0;
            hddid.Value = "0";
        }
    }
}