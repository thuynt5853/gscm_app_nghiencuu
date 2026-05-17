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
using System.Windows.Forms;
using static DevExpress.Xpo.Helpers.AssociatedCollectionCriteriaHelper;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.Menu;
using Label = System.Web.UI.WebControls.Label;

namespace WEB.GSTP.QLAN.HOAGIAI
{
    public partial class PhanCongThamPhan : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private HOAGIAI_BL _hoaGiaiBl = new HOAGIAI_BL();
        private static CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal loaiAn = 0;
        public Decimal vuViecId = 0;
        private bool isUpdateAction = true;
        private bool isDeleteRow = false;
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
                this.isUpdateAction = checkQuyen();

				LoadThamPhan();
				loadHGV();
				LoadToaAnTrucThuoc();
				LoadNguoiPhanCong();
				LoadNguoiPhanCongHGV();
				LoadVaiTro();
				//ddlHGV.Items.Insert(0, new ListItem("-----Chọn-----", "0"));
				//ddlToaAnTrucThuoc.Items.Insert(0, new ListItem("-----Chọn-----", "0"));
				ddlVaitro_SelectedIndexChanged(new object(), new EventArgs());
				LoadGrid();
			}
		}

        public bool checkQuyen()
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
                lbthongbao.Text = "Vụ việc đã được phân công thẩm phán giải quyết đơn. Không được sửa!";
                return false;
            }
            var checkThuLy = _hoaGiaiBl.CheckThuLy(vuViecId, loaiAn);
            if (checkThuLy)
            {
                Cls_Comon.SetButton(btnUpdate, true);
            }
            else
            {
                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc đã được thụ lý. Không được sửa!";
                return false;
            }
            var hoaGiaiDon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {vuViecId} AND LOAIANID = {loaiAn}").FirstOrDefault();

            var qd = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {hoaGiaiDon.ID}").FirstOrDefault();
            if (qd != null)
            {
                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc đã có quyết định. Không được sửa!";
                return false;
            }

            HOAGIAI_THONGBAO_KETQUA hgTBKhongHG = DataExtensions.GetAllWithClause<HOAGIAI_THONGBAO_KETQUA>($"HOAGIAIID = {hoaGiaiDon.ID} AND LUACHONID = {(decimal)ENUM_LUACHON_HOAGIAI.KHONG_HOAGIAI}").FirstOrDefault();
            if (hgTBKhongHG != null)
            {
                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                lblThongBao.Text = "Vụ việc được trả lời là không hòa giải. Không được thêm !";
                return false;
            }
            return true;
        }
        #region Kiểm tra xem có được xóa bản ghi hay không
        private bool CheckDuocXoa()
        {
            bool result = false;

            try
            {
                loaiAn = Convert.ToDecimal(hddLoaiAn.Value);
                vuViecId = Convert.ToDecimal(hddVuViecId.Value);
                var hoaGiaiDon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {vuViecId} AND LOAIANID = {loaiAn}").FirstOrDefault();
                var ghiNhanKetQua = DataExtensions.GetAllWithClause<HOAGIAI_GHINHANKETQUA>($"HOAGIAIID = {hoaGiaiDon.ID}").FirstOrDefault();
                if (ghiNhanKetQua != null)
                {
                    return false;
                }
                return true;
            }
            catch
            {

            }
            return result;
        }
        #endregion Kiểm tra xem có được xóa bản ghi hay không

        private void LoadVaiTro()
        {
            ddlVaitro.Items.Clear();
            ddlVaitro.Items.Add(new ListItem() { Value = "1", Text = $"Thẩm phán phụ trách {hoagiaitext}" });
            ddlVaitro.Items.Add(new ListItem() { Value = "2", Text = $"Hòa giải viên" });
            ddlVaitro.SelectedValue = "1";
        }

        private void LoadThamPhan()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphan.DataSource = oCBDT;
            ddlThamphan.DataTextField = "MA_TEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
        }

		private void LoadNguoiPhanCong()
		{
			DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
			ddlNguoiphancong.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_3CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA, ENUM_CHUCVU.TP + "," + ENUM_CHUCVU.TPSC + "," + ENUM_CHUCVU.TPTC + "," + ENUM_CHUCVU.TPCC + "" + ENUM_CHUCVU.TPTATC);
			ddlNguoiphancong.DataTextField = "MA_TEN";
			ddlNguoiphancong.DataValueField = "ID";
			ddlNguoiphancong.DataBind();
		}
		private void LoadNguoiPhanCongHGV()
		{
			DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
			ddlNguoiPhanCongHGV.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
			ddlNguoiPhanCongHGV.DataTextField = "MA_TEN";
			ddlNguoiPhanCongHGV.DataValueField = "ID";
			ddlNguoiPhanCongHGV.DataBind();
		}
		private void LoadToaAnTrucThuoc()
		{
			DM_TOAAN_BL oBL = new DM_TOAAN_BL();
			ddlToaAnTrucThuoc.DataSource = oBL.DM_TOAAN_GETBY(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
			ddlToaAnTrucThuoc.DataTextField = "arrTEN";
			ddlToaAnTrucThuoc.DataValueField = "ID";
			ddlToaAnTrucThuoc.DataBind();
            ddlToaAnTrucThuoc.Items.Insert(0, new ListItem("-----Chọn-----", "0"));
        }

        private void loadHGV(decimal selectedId = 0)
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_HGV);
            ddlHGV.DataSource = oCBDT;
            ddlHGV.DataTextField = "MA_TEN";
            ddlHGV.DataValueField = "ID";
            if (selectedId > 0)
                ddlHGV.SelectedValue = selectedId.ToString();
            ddlHGV.DataBind();
            pnHGVOption.Visible = false;
            ddlHGV.Items.Insert(0, new ListItem("-----Chọn-----", "0"));
        }

        private void LoadGrid()
        {
            if (this.vuViecId == 0)
                return;
            this.isDeleteRow = true;// CheckDuocXoa();
            HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();

            int page_size = Convert.ToInt32(hddPageSize.Value),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            var tbl = hoaGiaiBL.GetAllPhanCongThamPhan(V_HGDON: Convert.ToDecimal(hddHoaGiaiId.Value), PageSize: page_size, PageIndex: pageindex);
            //if (tbl.Rows.Count > 0)
            //{
            //    #region "Xác định số lượng trang"

            //    count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
            //    hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
            //    lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            //    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
            //                 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

            //    #endregion "Xác định số lượng trang"
            //}
            //else
            //{
            //    hddTotalPage.Value = "1";
            //    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
            //               lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            //    lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            //}
            dgList.CurrentPageIndex = 0;
            dgList.PageSize = page_size;
            dgList.DataSource = tbl;
            dgList.DataBind();
        }

		protected void rdbIsLuaChonHGV_SelectedIndexChanged(object sender, EventArgs e)
		{
			if (rdbIsLuaChonHGV.SelectedValue == "2")
			{
				pnHGVOption.Visible = true;
				//HOAGIAI_THONGBAO_KETQUA ketQua = DataExtensions.GetAllWithClause<HOAGIAI_THONGBAO_KETQUA>($"HOAGIAIID = {Convert.ToDecimal(hddHoaGiaiId.Value)} AND HOAGIAIVIENID > 0 ORDER BY NGAYTAO DESC").FirstOrDefault();
				//if (ketQua != null && ketQua.HOAGIAIVIENID > 0)
				//	loadHGV(ketQua.HOAGIAIVIENID.Value);
			}
			else
				pnHGVOption.Visible = false;
		}

		protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
		{
			try
			{
				decimal CurrID = Convert.ToDecimal(e.CommandArgument.ToString());
				string current_id = CurrID.ToString();
				decimal APID = Convert.ToDecimal(current_id);
				int rowIndex = e.Item.ItemIndex;
				string vaiTro = ((Label)e.Item.FindControl("VAITRO")).Text;
				switch (e.CommandName)
				{
					case "Sua":
						LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");

                        if (lblSua.Text == "Sửa")
                        {
                            Cls_Comon.SetButton(btnUpdate, true);
                        }
                        else
                        {
                            Cls_Comon.SetButton(btnUpdate, false);
                        }
                        HOAGIAI_THAMPHAN hgTP = DataExtensions.FindById<HOAGIAI_THAMPHAN>(APID);
                        if (rowIndex == 0 || rowIndex % 2 == 0)
                        {

							if (hgTP.HOAGIAIVIENID != null)
							{
								ddlVaitro.SelectedValue = "2";
								ddlVaitro.Items[0].Attributes["disabled"] = "disabled";
								ddlVaitro_SelectedIndexChanged(new object(), new EventArgs());
								if (hgTP != null)
								{
									txtGhiChu.Text = hgTP.LYDOCHIDINH;
									txtNgayChiDinh.Text = hgTP.NGAYCHIDINH?.ToVNDate().Replace("-", "/");
									rdbIsLuaChonHGV.SelectedValue = hgTP.LUACHONHGV.ToString();
									this.rdbIsLuaChonHGV_SelectedIndexChanged(null, null);
									ddlHGV.SelectedValue = hgTP.HOAGIAIVIENID.ToString();
									ddlToaAnTrucThuoc.SelectedValue = hgTP.TOAANHGV.ToString();
									txtHoaGiaThamPhanId.Text = hgTP.ID.ToString();
									ddlNguoiPhanCongHGV.SelectedValue = hgTP.NGUOIPHANCONGID.ToString();
									txtNguoiKyCD.Text = hgTP.NGUOIKY;
									txtGhiChuLC.Text = hgTP.GHICHU;
								}
							}
							else
							{
								ddlVaitro.SelectedValue = "1";
								ddlVaitro.Items[1].Attributes["disabled"] = "disabled";
								ddlVaitro_SelectedIndexChanged(new object(), new EventArgs());
								if (hgTP != null)
								{
									txtNgayphancong.Text = hgTP.NGAYPHANCONG.ToVNDate().Replace("-", "/");
									txtNhanphancong.Text = hgTP.NGAYNHANPHANCONG.ToVNDate().Replace("-", "/");
									ddlThamphan.SelectedValue = hgTP.THAMPHANID.ToString();
									ddlNguoiphancong.SelectedValue = hgTP.NGUOIPHANCONGID.ToString();
									txtHoaGiaThamPhanId.Text = hgTP.ID.ToString();
									txtGhiChuPC.Text = hgTP.GHICHU;
								}
							}
						}
						else
						{
							if (hgTP.HOAGIAIVIENID != null)
							{
								ddlVaitro.SelectedValue = "2";
								ddlVaitro.Items[0].Attributes["disabled"] = "disabled";
								ddlVaitro_SelectedIndexChanged(new object(), new EventArgs());
								if (hgTP != null)
								{
									txtGhiChu.Text = hgTP.LYDOCHIDINH;
									txtNgayChiDinh.Text = hgTP.NGAYCHIDINH?.ToVNDate().Replace("-", "/");
									rdbIsLuaChonHGV.SelectedValue = hgTP.LUACHONHGV.ToString();
									txtHoaGiaThamPhanId.Text = hgTP.ID.ToString();
									this.rdbIsLuaChonHGV_SelectedIndexChanged(null, null);
									ddlHGV.SelectedValue = hgTP.HOAGIAIVIENID.ToString();
									ddlToaAnTrucThuoc.SelectedValue = hgTP.TOAANHGV.ToString();
									ddlNguoiPhanCongHGV.SelectedValue = hgTP.NGUOIPHANCONGID.ToString();
									txtNguoiKyCD.Text = hgTP.NGUOIKY;
									txtGhiChuLC.Text = hgTP.GHICHU;
								}
							}
							else
							{
								ddlVaitro.SelectedValue = "1";
								ddlVaitro.Items[1].Attributes["disabled"] = "disabled";
								ddlVaitro_SelectedIndexChanged(new object(), new EventArgs());
								if (hgTP != null)
								{

                                    txtNgayphancong.Text = hgTP.NGAYPHANCONG.ToVNDate().Replace("-", "/");
                                    txtNhanphancong.Text = hgTP.NGAYNHANPHANCONG.ToVNDate().Replace("-", "/");
                                    ddlThamphan.SelectedValue = hgTP.THAMPHANID.ToString();
                                    ddlNguoiphancong.SelectedValue = hgTP.NGUOIPHANCONGID.ToString();
                                    txtHoaGiaThamPhanId.Text = hgTP.ID.ToString();
                                    txtGhiChuPC.Text = hgTP.GHICHU;
                                }
                            }
                        }

                        break;

                    case "Xoa":
                        HOAGIAI_THAMPHAN hgHGV = DataExtensions.FindById<HOAGIAI_THAMPHAN>(APID);

                        try
                        {
                            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                            if (oPer.XOA == false || btnUpdate.Enabled == false)
                            {
                                lblThongBao.Text = "Bạn không có quyền xóa!";
                                return;
                            }

                            bool result = DataExtensions.Delete<HOAGIAI_THAMPHAN>(new HOAGIAI_THAMPHAN() { ID = APID });
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

        private void statusDel(bool pc)
        {
            if (pc)
            {
                lblThongBao.Text = "Xóa thành công!";
                this.LoadGrid();
                this.ResetControl();
            }
            else
            {
                lblThongBao.Text = "Không thể xóa hãy thử lại";
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

                if (!this.isDeleteRow)
                {
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }

                if (this.isUpdateAction)
                {
                    lblSua.Text = "Sửa";
                }
                else
                {
                    lbtXoa.Visible = false;
                    lblSua.Text = "Chi tiết";
                }

                if (rowView["READONLY"] + "" == "1")
                {
                    lbtXoa.Visible = false;
                    lblSua.Text = "Chi tiết";
                }
                //loaiAn = Convert.ToDecimal(hddLoaiAn.Value);
                //vuViecId = Convert.ToDecimal(hddVuViecId.Value);
                //var checkPCTPQGD = _hoaGiaiBl.CheckPCTPQGD(this.vuViecId, this.loaiAn);
                //if (checkPCTPQGD)
                //{
                //    lblSua.Visible = lbtXoa.Visible = true;
                //    lblSua.Text = "Sửa";
                //}
                //else
                //{
                //    lblSua.Visible = lbtXoa.Visible = false;
                //    lblSua.Text = "Chi tiết";
                //}
                //var checkThuLy = _hoaGiaiBl.CheckThuLy(vuViecId, loaiAn);
                //if (checkThuLy)
                //{
                //    lblSua.Visible = lbtXoa.Visible = true;
                //    lblSua.Text = "Sửa";
                //}
                //else
                //{
                //    lblSua.Visible = lbtXoa.Visible = false;
                //    lblSua.Text = "Chi tiết";
                //}
                //if (!Convert.ToBoolean(hddShowCommand.Value))
                //{
                //    lblSua.Visible = lbtXoa.Visible = false;
                //    lblSua.Text = "Chi tiết";
                //}
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {

            if (!CheckValid()) return;
            else
            {
                if (this.checkQuyen() == false)
                {
                    return;
                }
                string idStr = txtHoaGiaThamPhanId.Text;
                decimal idHGTP = 0;
                if (!String.IsNullOrEmpty(idStr))
                {
                    idHGTP = Convert.ToDecimal(idStr);
                }
                HOAGIAI_THAMPHAN hoaGiai = new HOAGIAI_THAMPHAN();
                if (idHGTP != 0)
                {
                    hoaGiai = DataExtensions.FindById<HOAGIAI_THAMPHAN>(idHGTP);

                }

				if (ddlVaitro.SelectedValue == "1")
				{
					hoaGiai.THAMPHANID = Convert.ToDecimal(ddlThamphan.SelectedValue);
					hoaGiai.NGAYPHANCONG = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
					hoaGiai.NGAYNHANPHANCONG = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
					hoaGiai.NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiphancong.SelectedValue);
					hoaGiai.LUACHONHGV = Convert.ToDecimal(rdbIsLuaChonHGV.SelectedValue);
					
					hoaGiai.GHICHU = txtGhiChuPC.Text;
					hoaGiai.MAVAITRO = "THAMPHAN";
				}


                if (ddlVaitro.SelectedValue == "2")
                {
                    hoaGiai.LUACHONHGV = Convert.ToDecimal(rdbIsLuaChonHGV.SelectedValue);
                    hoaGiai.HOAGIAIVIENID = Convert.ToDecimal(ddlHGV.SelectedValue);
                    if (rdbIsLuaChonHGV.SelectedValue == "1")
                    {
                        hoaGiai.NGAYCHIDINH = null;
                        hoaGiai.LYDOCHIDINH = null;
                    }
                    else
                    {
                        hoaGiai.NGAYCHIDINH = (String.IsNullOrEmpty(txtNgayChiDinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayChiDinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        hoaGiai.LYDOCHIDINH = txtGhiChu.Text;
                    }
                    hoaGiai.TOAANHGV = Convert.ToDecimal(ddlToaAnTrucThuoc.SelectedValue);
                    hoaGiai.NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiPhanCongHGV.SelectedValue);
                    hoaGiai.NGUOIKY = txtNguoiKyCD.Text;
                    hoaGiai.GHICHU = txtGhiChuLC.Text;
                    hoaGiai.MAVAITRO = "HOAGIAIVIEN";
                }


                //if (Convert.ToDecimal(rdbIsLuaChonHGV.SelectedValue) == 2)
                //{
                //    hoaGiai.NGAYCHIDINH = (String.IsNullOrEmpty(txtNgayChiDinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayChiDinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //    hoaGiai.LYDOCHIDINH = txtGhiChu.Text;
                //}
                //else
                //{
                //    hoaGiai.NGAYCHIDINH = null;
                //    hoaGiai.LYDOCHIDINH = null;
                //}
                if (idHGTP == 0)
                {
                    hoaGiai.NGAYTAO = DateTime.Now;
                    hoaGiai.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                }
                else
                {
                    hoaGiai.NGAYSUA = DateTime.Now;
                    hoaGiai.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                }
                HOAGIAI_DON hg = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID={this.vuViecId}").FirstOrDefault();
                hoaGiai.HOAGIAIID = hg.ID;
                bool isAction = false;


                if (idHGTP == 0)
                {
                    decimal isInsert = DataExtensions.Insert<HOAGIAI_THAMPHAN>(hoaGiai);
                    if (isInsert != 0)
                    {
                        isAction = true;
                    }
                }
                else
                {
                    isAction = DataExtensions.Update<HOAGIAI_THAMPHAN>(hoaGiai);
                }
                if (isAction)
                {
                    lblThongBao.Text = "Lưu thành công";
                    this.btnLammoi_Click(null, null);
                }
                else
                {
                    lblThongBao.Text = "Có lỗi trong quá trình xử lý";
                    return;
                }
            }
            ResetControl();

        }

        private bool CheckValid()
        {
            if (ddlVaitro.SelectedValue == "2")
            {
                if (ddlHGV.SelectedValue == "0")
                {
                    lblThongBao.Text = "Bạn chưa lựa chọn hòa giải viên. Hãy chọn lại!";
                    ddlHGV.Focus();
                    return false;
                }

                if (ddlToaAnTrucThuoc.SelectedValue == "0")
                {
                    lblThongBao.Text = "Bạn chưa lựa chọn Tòa án trực thuộc. Hãy chọn lại!";
                    ddlToaAnTrucThuoc.Focus();
                    return false;
                }
            }


            return true;
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            this.ResetControl();
            this.LoadGrid();
            txtHoaGiaThamPhanId.Text = string.Empty;
        }

        protected void ResetControl()
        {
            txtGhiChu.Text = "";
            hddid.Value = "";
            txtNgayChiDinh.Text = "";
            txtNgayphancong.Text = "";
            txtNhanphancong.Text = "";
            ddlHGV.SelectedIndex = 0;
            ddlThamphan.SelectedIndex = 0;
            rdbIsLuaChonHGV.SelectedIndex = 0;
            ddlNguoiphancong.SelectedIndex = 0;
            ddlNguoiPhanCongHGV.SelectedIndex = 0;
            LoadVaiTro();
            ddlVaitro_SelectedIndexChanged(new object(), new EventArgs());
            ddlToaAnTrucThuoc.SelectedIndex = 0;
            txtNguoiKyCD.Text = "";
            this.rdbIsLuaChonHGV_SelectedIndexChanged(null, null);
            txtGhiChuPC.Text = "";
            txtGhiChuLC.Text = "";
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

        #endregion "Phân trang"




        protected void ddlVaitro_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlVaitro.SelectedValue == "2")
            {
                pnlPhanCong.Visible = false;
                pnlChiDinh.Visible = true;
            }
            else
            {

                pnlPhanCong.Visible = true;
                pnlChiDinh.Visible = false;
            }
        }

	}
}