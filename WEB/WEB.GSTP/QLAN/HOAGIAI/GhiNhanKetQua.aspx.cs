using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.HOAGIAI;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.HOAGIAI;
using BL.GSTP.Quantri;
using DAL.GSTP;
using DevExpress.Office.Utils;
using DevExpress.Utils.MVVM;
using Microsoft.Office.Interop.Excel;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using DataTable = System.Data.DataTable;

namespace WEB.GSTP.QLAN.HOAGIAI
{
	public partial class GhiNhanKetQua : System.Web.UI.Page
	{
		private QT_FILE_BL fileHelper = new QT_FILE_BL();
		private CultureInfo cul = new CultureInfo("vi-VN");
		public Decimal loaiAn = 0;
		public Decimal vuViecId = 0;
		private GSTPContext dt = new GSTPContext();
		private HOAGIAI_BL _hoaGiaiBl = new HOAGIAI_BL();
		private bool isUpdateAction = true;
		public string hoagiaitext = "hoà giải";
		protected void Page_Load(object sender, EventArgs e)
		{
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

			var hoaGiaiDon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {vuViecId} AND LOAIANID = {loaiAn}").FirstOrDefault();
			if (hoaGiaiDon == null)
				Response.Redirect(returnURL);
			if (!IsPostBack)
			{
				MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
				Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
				Cls_Comon.SetButton(btnLammoi, oPer.CAPNHAT);
				this.isUpdateAction = this.checkQuyen();
				lstDllKetQua = new List<ListItem>() {
					new ListItem("----Chọn----", ((int)ENUM_TRANGTHAI_HOAGIAI.NULL).ToString()),
					new ListItem(char.ToUpper(hoagiaitext[0]) + hoagiaitext.Substring(1) +" thành", ((int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH).ToString()),
					new ListItem(char.ToUpper(hoagiaitext[0]) + hoagiaitext.Substring(1) +" không thành", ((int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH).ToString()),
					new ListItem("Đương sự rút đơn", ((int)ENUM_TRANGTHAI_HOAGIAI.DUONGSU_RUTDON).ToString()),
					new ListItem("Hoãn", ((int)ENUM_TRANGTHAI_HOAGIAI.HOAN).ToString())};
				this.InitData(hoaGiaiDon);
				this.LoadGrid();
			}
			else
			{
				lblThongBao.Text = "";
			}
		}

		public bool checkQuyen()
		{
			var checkThuLy = _hoaGiaiBl.CheckThuLy(this.vuViecId, this.loaiAn);
			if (checkThuLy)
			{
				//btnUpdate.Visible = true;
				Cls_Comon.SetButton(btnUpdate, true);
			}
			else
			{
				//btnUpdate.Visible = false;
				Cls_Comon.SetButton(btnUpdate, false);
				hddShowCommand.Value = "False";
				lblThongBao.Text = "Vụ việc đã được thụ lý. Không được sửa!";
				return false;
			}
			var hoaGiaiDon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {this.vuViecId} AND LOAIANID = {this.loaiAn}").FirstOrDefault();
			var pctp = DataExtensions.GetAllWithClause<HOAGIAI_THAMPHAN>($"HOAGIAIID = {hoaGiaiDon.ID}").FirstOrDefault();
			if (pctp == null)
			{
				//btnUpdate.Visible = false;
				Cls_Comon.SetButton(btnUpdate, false);
				hddShowCommand.Value = "False";
				lblThongBao.Text = "Chưa phân công thẩm phán/Chỉ định hoà giải viên";
				this.isUpdateAction = false;
				return false;
			}

			var qd = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {hoaGiaiDon.ID}").FirstOrDefault();
			if (qd != null)
			{
				Cls_Comon.SetButton(btnUpdate, false);
				hddShowCommand.Value = "False";
				lblThongBao.Text = "Vụ việc đã có quyết định. Không được sửa!";
				this.isUpdateAction = false;
				return false;
			}
			return true;
		}

		private List<ListItem> lstDllKetQua = new List<ListItem>() {
			new ListItem("----Chọn----", ((int)ENUM_TRANGTHAI_HOAGIAI.NULL).ToString()),
			new ListItem("Hoà giải thành", ((int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH).ToString()),
			new ListItem("Hoà giải không thành", ((int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH).ToString()),
			new ListItem("Đương sự rút đơn", ((int)ENUM_TRANGTHAI_HOAGIAI.DUONGSU_RUTDON).ToString()),
			new ListItem("Hoãn", ((int)ENUM_TRANGTHAI_HOAGIAI.HOAN).ToString())
		};

		private void InitData(HOAGIAI_DON hgDon)
		{
			#region Kết quả hòa giải,đối thoại

			dllKetQua.Items.AddRange(this.lstDllKetQua.ToArray());

			#endregion Kết quả hòa giải,đối thoại

			#region Yêu cầu quyết định

			ddlYeuCauQuyetDinh.Items.Add(new ListItem("Đề nghị", ((int)ENUM_QD_CONGNHAN_HOAGIAI_THANH.DE_NGHI).ToString()));
			ddlYeuCauQuyetDinh.Items.Add(new ListItem("Không đề nghị", ((int)ENUM_QD_CONGNHAN_HOAGIAI_THANH.KHONG_DE_NGHI).ToString()));

			#endregion Yêu cầu quyết định

			#region Lý do hòa giải không thành

			//ENUM_LYDO_HOAGIAI_KHONGTHANH
			//LYDO_HOAGIAI_KHONGTHANH
			DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
			DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LYDO_HOAGIAI_KHONGTHANH);
			if (tbl != null && tbl.Rows.Count > 0)
			{
				ddlLyDoHoaGiaiKhongThanh.DataSource = tbl;
				ddlLyDoHoaGiaiKhongThanh.DataTextField = "TEN";
				ddlLyDoHoaGiaiKhongThanh.DataValueField = "ID";
				ddlLyDoHoaGiaiKhongThanh.DataBind();
				ddlLyDoHoaGiaiKhongThanh.Items.Insert(0, new ListItem("----Chọn----", "0"));
			}

			#endregion Lý do hòa giải không thành

			#region Người ký, Chức vụ

			DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();

			#region Lấy phân công với ngày nhận phân công là mới nhất

			List<Decimal?> lstThamPhanID = DataExtensions.GetAllWithClause<HOAGIAI_THAMPHAN>($"HOAGIAIID = {hgDon.ID} AND THAMPHANID IS NOT NULL").Select(i => i.THAMPHANID).ToList();
			List<decimal> _lstID = new List<decimal>();
			lstThamPhanID.ForEach(i =>
			{
				if (i != null)
					_lstID.Add((decimal)i);
			});

			#endregion Lấy phân công với ngày nhận phân công là mới nhất

			if (_lstID != null)
			{
				DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
				ddlNguoiKy.Items.Clear();
				foreach(DataRow item in oCBDT.Rows)
				{
					decimal id = Convert.ToDecimal(item["ID"].ToString());
					if (_lstID.Contains(id))
						ddlNguoiKy.Items.Add(new ListItem() { Value = item["ID"].ToString(), Text = item["MA_TEN"].ToString() });
				}	
				//DataTable thamPhanInfor = oDMCBBL.DM_MANY_CANBO_GETINFOBYID(_lstID);
				//if (thamPhanInfor.Rows.Count > 0)
				//{
				//	var lstNguoiKy = (from row in thamPhanInfor.AsEnumerable()
				//					  select new ListItem(
				//						  row["HOTEN"].ToString() + " - " + (String.IsNullOrEmpty(row["CHUCVU"].ToString()) ? row["CHUCDANH"].ToString() : row["CHUCVU"].ToString()),
				//						  row["ID"].ToString())).ToList();
				//	ddlNguoiKy.DataSource = lstNguoiKy;
				//	ddlNguoiKy.DataValueField = "Value";
				//	ddlNguoiKy.DataTextField = "Text";
				//	ddlNguoiKy.DataBind();
				//}
			}

			#endregion Người ký, Chức vụ
		}

		public void LoadGrid()
		{
			if (this.vuViecId == 0 || this.loaiAn == 0)
				return;
			HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
			var tbl = hoaGiaiBL.GetAllGhiNhanKetQuaHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, PageSize: 0, PageIndex: 0);
			tbl.Columns.Add("KETQUATXT", typeof(System.String));

			foreach (DataRow row in tbl.Rows)
			{
				row["KETQUATXT"] = this.lstDllKetQua.FirstOrDefault(i => i.Value.ToString() == row["KETQUAID"].ToString()).Text;
			}

			dgList.CurrentPageIndex = 0;
			//dgList.PageSize = page_size;
			dgList.DataSource = tbl;
			dgList.DataBind();
		}

		protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
		{
			try
			{
				decimal APID = Convert.ToDecimal(e.CommandArgument.ToString());
				switch (e.CommandName)
				{
					case "Download":
						decimal FileID = Convert.ToDecimal(APID);
						QT_FILE fileSR = DataExtensions.FindById<QT_FILE>(FileID);
						if (fileSR != null)
						{
							var cacheKey = Guid.NewGuid().ToString("N");
							var NOIDUNG = fileHelper.GetNoiDungFile(fileSR, Convert.ToInt32(hddLoaiAn.Value));
							Context.Cache.Insert(key: cacheKey, value: NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
							ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + fileSR.FILE_NAME + "&Extension=" + fileSR.FILE_TYPE + "';", true);
						}
						break;

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
						HOAGIAI_GHINHANKETQUA hgTP = DataExtensions.FindById<HOAGIAI_GHINHANKETQUA>(APID);
						if (hgTP != null)
						{
							txtKetQuaHoaGiaiID.Text = hgTP.ID.ToString();
							txtNgayHoaGiai.Text = hgTP.NGAYHOAGIAI?.ToVNDate().Replace("-", "/");
							txtDiaDiem.Text = hgTP.DIADIEM;
							dllKetQua.SelectedValue = hgTP.KETQUAID.ToString();
							this.dllKetQua_SelectedIndexChanged(null, null);
							txtNgayQD.Text = hgTP.NGAYQUYETDINH?.ToVNDate().Replace("-", "/");
							txtSoQD.Text = hgTP.SOQUYETDINH;
							if (hgTP.KETQUAID == (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH)
							{
								ddlYeuCauQuyetDinh.SelectedValue = hgTP.YEUCAUQD.ToString();
							}

							if (hgTP.KETQUAID == (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH)
							{
								//Lý do hòa giải không thành
								ddlLyDoHoaGiaiKhongThanh.SelectedValue = hgTP.LYDOID.ToString();
							}

							if (hgTP.KETQUAID == (int)ENUM_TRANGTHAI_HOAGIAI.HOAN)
							{
								txtLyDoHoan.Text = hgTP.LYDOHOAN?.ToString();
								//Lý do Hoãn
							}

							if (hgTP.KETQUAID == (int)ENUM_TRANGTHAI_HOAGIAI.HOAN || hgTP.KETQUAID == (int)ENUM_TRANGTHAI_HOAGIAI.DUONGSU_RUTDON || hgTP.KETQUAID == (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH)
							{
								txtNgayThongBao.Text = hgTP.NGAYTHONGBAO?.ToVNDate().Replace("-", "/");
								txtThongBao.Text = hgTP.SOTHONGBAO;
							}

							if (hgTP.KETQUAID == (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH || hgTP.KETQUAID == (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH)
							{
								txtNgayLapbb.Text = hgTP.NGAYBIENBAN?.ToVNDate().Replace("-", "/");
							}
							if ((hgTP.FILEID + "") != "" && (hgTP.FILEID + "") != "0")
							{
								HOAGIAI_FILE hgFile = DataExtensions.FindById<HOAGIAI_FILE>(hgTP.FILEID.Value);
								if (hgFile != null)
								{
									lbtDownload.Text = hgFile.TENFILE + hgFile.DUOIFILE;
									lbtDownload.Visible = true;
									hddFileid.Value = hgFile.FILESERVER_ID + "";
								}
							}
							else
							{
								lbtDownload.Text = "Tải file đính kèm";
								lbtDownload.Visible = false;
							}
							#region Người ký, Chức vụ
							ddlNguoiKy.SelectedValue = hgTP.NGUOIKYID.ToString();
							#endregion Người ký, Chức vụ
						}
						break;

					case "Xoa":
						MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
						if (oPer.XOA == false || btnUpdate.Enabled == false)
						{
							lblThongBao.Text = "Bạn không có quyền xóa!";
							return;
						}
						try
						{
							HOAGIAI_GHINHANKETQUA ketQua = DataExtensions.FindById<HOAGIAI_GHINHANKETQUA>(APID);
							if (ketQua == null)
							{
								lblThongBao.Text = "Không tồn tại kết quả hòa giải";
								return;
							}
							bool result = DataExtensions.Delete<HOAGIAI_GHINHANKETQUA>(new HOAGIAI_GHINHANKETQUA() { ID = APID });
							if (ketQua.FILEID != null)
							{
								HOAGIAI_FILE hOAGIAI_FILE = DataExtensions.FindById<HOAGIAI_FILE>((decimal)ketQua.FILEID);
								QT_FILE qT_FILE = DataExtensions.FindById<QT_FILE>((decimal)hOAGIAI_FILE.FILESERVER_ID);
								QT_FILE_BL file_BL = new QT_FILE_BL();
								file_BL.DeleteFileLogic(qT_FILE);
							}
							if (result)
							{
								#region Nếu không có quyết định mới tiến hành cập nhật lại đơn theo ghi nhận kết quả

								HOAGIAI_QUYETDINH qUYETDINH = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {ketQua.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
								if (qUYETDINH == null)
								{
									HOAGIAI_GHINHANKETQUA ghiNhanKetQua = DataExtensions.GetAllWithClause<HOAGIAI_GHINHANKETQUA>($"HOAGIAIID = {ketQua.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

									#region nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

									if (ghiNhanKetQua == null)
									{
										this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI);
										Page.Response.Redirect(Page.Request.Url.ToString(), false);
										Context.ApplicationInstance.CompleteRequest();
										lblThongBao.Text = "Xóa thành công!";
										return;
									}
									else if (ghiNhanKetQua.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
									{
										this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ghiNhanKetQua.KETQUAID);
										Page.Response.Redirect(Page.Request.Url.ToString(), false);
										Context.ApplicationInstance.CompleteRequest();
										lblThongBao.Text = "Xóa thành công!";
										return;
									}

									#endregion nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật
								}

								#endregion Nếu không có quyết định mới tiến hành cập nhật lại đơn theo ghi nhận kết quả

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

		protected void dgList_ItemDataBound(object source, DataGridItemEventArgs e)
		{
			MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
			if (e.Item.ItemType == ListItemType.Header)
			{
				e.Item.Cells[1].Text = "Ngày diễn ra phiên " + hoagiaitext;
			}
			if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
			{
				DataRowView row = (DataRowView)e.Item.DataItem;
				var isExistsFile = String.IsNullOrEmpty(row["FILESID"].ToString());
				if (isExistsFile)
				{
					var button = (ImageButton)e.Item.FindControl("lblDownload");
					button.Visible = !isExistsFile;
				}

				LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
				Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

				LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
				Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

				if (this.isUpdateAction)
				{
					lblSua.Text = "Sửa";
					Cls_Comon.SetButton(btnUpdate, true);
				}
				else
				{
					lbtXoa.Visible = false;
					lblSua.Text = "Chi tiết";
					Cls_Comon.SetButton(btnUpdate, false);
				}

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
				//var checkThuLy = _hoaGiaiBl.CheckThuLy(this.vuViecId, this.loaiAn);
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
			try
			{
				if (this.checkQuyen() == false)
				{
					return;
				}
				string idStr = txtKetQuaHoaGiaiID.Text;
				decimal idHGTP = 0;
				if (!String.IsNullOrEmpty(idStr))
				{
					idHGTP = Convert.ToDecimal(idStr);
				}
				HOAGIAI_GHINHANKETQUA ketQua = new HOAGIAI_GHINHANKETQUA();
				if (idHGTP != 0)
				{
					ketQua = DataExtensions.FindById<HOAGIAI_GHINHANKETQUA>(idHGTP);
					if (ketQua == null)
					{
						lblThongBao.Text = "Dữ liệu không đúng";
						throw new Exception("Dữ liệu không đúng");
					}
					ketQua.YEUCAUQD = null;
					ketQua.LYDOID = null;
					ketQua.LYDOHOAN = null;
					ketQua.NGAYTHONGBAO = null;
					ketQua.SOTHONGBAO = null;
					ketQua.NGAYBIENBAN = null;
					ketQua.NGAYQUYETDINH = null;
					ketQua.SOQUYETDINH = null;
				}
				//ketQua.NGAYQUYETDINH = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); ;
				//ketQua.SOQUYETDINH = txtSoQD.Text;
				string userName = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
				ketQua.NGAYHOAGIAI = (String.IsNullOrEmpty(txtNgayHoaGiai.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayHoaGiai.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); ;
				ketQua.DIADIEM = txtDiaDiem.Text;

				var ketQuaHoaGiai = (ENUM_TRANGTHAI_HOAGIAI)Enum.Parse(typeof(ENUM_TRANGTHAI_HOAGIAI), dllKetQua.SelectedValue);

				ketQua.KETQUAID = (int)ketQuaHoaGiai;

				if (ketQuaHoaGiai == ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH)
				{
					ketQua.YEUCAUQD = Convert.ToDecimal(ddlYeuCauQuyetDinh.SelectedValue);
				}
				if (ketQuaHoaGiai == ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH)
				{
					//Lý do hòa giải không thành
					ketQua.LYDOID = Convert.ToDecimal(ddlLyDoHoaGiaiKhongThanh.SelectedValue);
				}
				if (ketQuaHoaGiai == ENUM_TRANGTHAI_HOAGIAI.HOAN)
				{
					//Lý do Hoãn
					ketQua.LYDOHOAN = txtLyDoHoan.Text;
				}

				if (ketQuaHoaGiai == ENUM_TRANGTHAI_HOAGIAI.HOAN || ketQuaHoaGiai == ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH || ketQuaHoaGiai == ENUM_TRANGTHAI_HOAGIAI.DUONGSU_RUTDON)
				{
					ketQua.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgayThongBao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayThongBao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
					ketQua.SOTHONGBAO = txtThongBao.Text;
				}

				if (ketQuaHoaGiai == ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH || ketQuaHoaGiai == ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH)
				{
					ketQua.NGAYBIENBAN = (String.IsNullOrEmpty(txtNgayLapbb.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayLapbb.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
				}

				if (idHGTP == 0)
				{
					ketQua.NGAYTAO = DateTime.Now;
					ketQua.NGUOITAO = userName;
				}
				else
				{
					ketQua.NGAYSUA = DateTime.Now;
					ketQua.NGUOISUA = userName;
				}

				if (!this.CheckValid(ketQua))
				{
					return;
				}
				HOAGIAI_DON hg = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID={this.vuViecId} AND LOAIANID={this.loaiAn}").FirstOrDefault();
				ketQua.HOAGIAIID = hg.ID;
				if (hddFilePath.Value != "")
				{
					try
					{
						string strFilePath = hddFilePath.Value.Replace("/", "\\");
						QT_FILE itemFile = fileHelper.InsertFile(strFilePath, Convert.ToInt32(hddLoaiAn.Value));
						HOAGIAI_FILE hgFile = new HOAGIAI_FILE()
						{
							DUOIFILE = itemFile.FILE_TYPE,
							FILESERVER_ID = itemFile.ID,
							KICHTHUOC = itemFile.FILE_SIZE,
							TENFILE = itemFile.FILE_NAME
						};
						DataExtensions.Insert(hgFile);
						ketQua.FILEID = hgFile.ID;
						System.IO.File.Delete(strFilePath);
						hddFilePath.Value = "";
					}
					catch (Exception ex) { lblThongBao.Text = ex.Message; }
				}

				#region Người ký, Chức vụ

				DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
				DataTable thamPhanInfor = oDMCBBL.DM_CANBO_GETINFOBYID(Convert.ToDecimal(ddlNguoiKy.SelectedValue));
				if (thamPhanInfor.Rows.Count > 0)
				{
					ketQua.NGUOIKYID = Convert.ToDecimal(ddlNguoiKy.SelectedValue);
					DataRow row = thamPhanInfor.Rows[0];
					ketQua.NGUOIKY = row["HOTEN"].ToString();
					ketQua.CHUCVU = String.IsNullOrEmpty(row["CHUCVU"].ToString()) ? row["CHUCDANH"].ToString() : row["CHUCVU"].ToString();
				}
				else
				{
					lblThongBao.Text = "Không tồn tại người ký bạn vừa chọn";
					return;
				}

				#endregion Người ký, Chức vụ

				bool isAction = false;
				if (idHGTP == 0)
				{
					decimal isInsert = DataExtensions.Insert<HOAGIAI_GHINHANKETQUA>(ketQua);
					if (isInsert != 0)
					{
						isAction = true;
					}
				}
				else
				{
					isAction = DataExtensions.Update<HOAGIAI_GHINHANKETQUA>(ketQua);
				}
				if (isAction)
				{
					#region Nếu không có quyết định mới tiến hành cập nhật lại đơn theo ghi nhận kết quả

					HOAGIAI_QUYETDINH qUYETDINH = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {ketQua.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
					if (qUYETDINH == null)
					{
						HOAGIAI_GHINHANKETQUA ghiNhanKetQua = DataExtensions.GetAllWithClause<HOAGIAI_GHINHANKETQUA>($"HOAGIAIID = {ketQua.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC,ID DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

						#region Nếu kết quả hiện tại là kết quả lớn nhất thì mới cập nhật lại trạng thái
						decimal? trangThai = this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn);

						if (trangThai == null || (trangThai != null && ghiNhanKetQua.KETQUAID != trangThai))
						{
							this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ghiNhanKetQua.KETQUAID);
							Page.Response.Redirect(Page.Request.Url.ToString(), false);
							Context.ApplicationInstance.CompleteRequest();
							lblThongBao.Text = "Lưu thành công";
							return;
						}
						#endregion Nếu kết quả hiện tại là kết quả lớn nhất thì mới cập nhật lại trạng thái
					}

					#endregion Nếu không có quyết định mới tiến hành cập nhật lại đơn theo ghi nhận kết quả

					this.LoadGrid();
					lblThongBao.Text = "Lưu thành công";
					this.btnLammoi_Click(null, null);
				}
				else
				{
					lblThongBao.Text = "Có lỗi trong quá trình xử lý";
					return;
				}
			}
			catch
			{
				lblThongBao.Text = "Dữ liệu không đúng";
			}
		}

		private bool CheckValid(HOAGIAI_GHINHANKETQUA ketQua)
		{
			if (ketQua.NGAYHOAGIAI == null)
			{
				lblThongBao.Text = "Ngày diễn ra phiên " + hoagiaitext + " không được để trống";
				return false;
			}
			if (ketQua.KETQUAID == null || ketQua.KETQUAID == (int)ENUM_TRANGTHAI_HOAGIAI.NULL)
			{
				lblThongBao.Text = "Kết quả không được để trống";
				return false;
			}
			if (ketQua.KETQUAID == (int)ENUM_TRANGTHAI_HOAGIAI.HOAN)
			{
				if (ketQua.NGAYTHONGBAO == null || String.IsNullOrEmpty(ketQua.SOTHONGBAO))
				{
					lblThongBao.Text = "Ngày thông báo, Số thông báo không được để trống";
					return false;
				}
			}
			try
			{
				decimal canBoID = Convert.ToDecimal(ddlNguoiKy.SelectedValue);
				if (canBoID <= 0)
				{
					lblThongBao.Text = "Người ký không được để trống";
					return false;
				}
			}
			catch
			{
				return false;
			}
			return true;
			//if (ketQua.NGAYQUYETDINH == null)
			//{
			//    lblThongBao.Text = "Ngày quyết định không được để trống";
			//    throw new Exception("Ngày quyết định không được để trống");
			//}
			//if (ketQua.SOQUYETDINH == null)
			//{
			//    lblThongBao.Text = "Số quyết định không được để trống";
			//    throw new Exception("Số quyết định không được để trống");
			//}
			//if (String.IsNullOrEmpty(ketQua.NGUOIKY))
			//{
			//    lblThongBao.Text = "Người ký không được để trống";
			//    throw new Exception("Người ký không được để trống");
			//}
			//if (String.IsNullOrEmpty(ketQua.CHUCVU))
			//{
			//    lblThongBao.Text = "Chức vụ không được để trống";
			//    throw new Exception("Chức vụ không được để trống");
			//}
		}

		protected void btnLammoi_Click(object sender, EventArgs e)
		{
			this.ResetControls();
			this.dllKetQua_SelectedIndexChanged(null, null);
		}

		protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
		{
			if (AsyncFileUpLoad.HasFile)
			{
				string strFileName = AsyncFileUpLoad.FileName;
				string path = Server.MapPath("~/TempUpload/") + strFileName;
				AsyncFileUpLoad.SaveAs(path);

				path = path.Replace("\\", "/");
				ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
			}
		}

		protected void dllKetQua_SelectedIndexChanged(object sender, EventArgs e)
		{
			try
			{
				string requied = "<span style='color:red'>(*)</span>";
				pnYeuCauQuyetDinh.Visible = false;
				pnLyDoHoan.Visible = false;
				pnNgayVaSoThongBao.Visible = false;
				pnNgayLapBienBan.Visible = false;
				pnLyDoHoaGiaiKhongThanh.Visible = false;
				pnQuyetDinh.Visible = false;
				pnNgayVaSoThongBao.Visible = false;
				txtNgayThongBao.CssClass = txtNgayThongBao.CssClass.Replace(" d-validator-required", "");
				txtThongBao.CssClass = txtThongBao.CssClass.Replace(" d-validator-required", "");
				ltNgayRaThongBao.Text = ltSoThongBao.Text = "";

				ENUM_TRANGTHAI_HOAGIAI trangThaiHG = (ENUM_TRANGTHAI_HOAGIAI)Enum.Parse(typeof(ENUM_TRANGTHAI_HOAGIAI), dllKetQua.SelectedValue);

				switch (trangThaiHG)
				{
					case ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH:
						pnYeuCauQuyetDinh.Visible = true;
						pnNgayLapBienBan.Visible = true;
						break;

					case ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH:
						pnLyDoHoaGiaiKhongThanh.Visible = true;
						//pnNgayVaSoThongBao.Visible = true;
						pnNgayLapBienBan.Visible = true;
						break;

					case ENUM_TRANGTHAI_HOAGIAI.DUONGSU_RUTDON:
						pnNgayVaSoThongBao.Visible = true;
						break;

					case ENUM_TRANGTHAI_HOAGIAI.HOAN:
						pnLyDoHoan.Visible = true;
						pnNgayVaSoThongBao.Visible = true;
						ltNgayRaThongBao.Text = ltSoThongBao.Text = requied;
						txtNgayThongBao.CssClass += " d-validator-required";
						txtThongBao.CssClass += " d-validator-required";
						break;
					//case ENUM_TRANGTHAI_HOAGIAI.NULL:
					//    break;
					default:
						break;
				}
			}
			catch
			{
			}
		}

		private void ResetControls()
		{
			txtNgayHoaGiai.Text =
				txtDiaDiem.Text =
				txtLyDoHoan.Text =
				//txtChuVu.Text =
				//txtNguoiKy.Text =
				txtNgayThongBao.Text =
				txtThongBao.Text =
				txtNgayLapbb.Text =
				txtNgayQD.Text =
				txtSoQD.Text = "";
			hddFilePath.Value = "";
			txtKetQuaHoaGiaiID.Text = "";

			lbtDownload.Text = "";
			lbtDownload.Visible = false;
			dllKetQua.SelectedIndex = (int)ENUM_TRANGTHAI_HOAGIAI.NULL;
			ddlYeuCauQuyetDinh.SelectedIndex = 0;
			ddlNguoiKy.SelectedIndex = 0;
		}
		protected void lbtDownload_Click(object sender, EventArgs e)
		{
			decimal FileID = Convert.ToDecimal(hddFileid.Value);
			QT_FILE fileSR = DataExtensions.FindById<QT_FILE>(FileID);
			if (fileSR != null)
			{
				var cacheKey = Guid.NewGuid().ToString("N");
				var NOIDUNG = fileHelper.GetNoiDungFile(fileSR, Convert.ToInt32(hddLoaiAn.Value));
				Context.Cache.Insert(key: cacheKey, value: NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
				ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + fileSR.FILE_NAME + "&Extension=" + fileSR.FILE_TYPE + "';", true);
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

		#endregion "Phân trang"
	}
}