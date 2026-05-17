using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.HOAGIAI;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.HOAGIAI;
using BL.GSTP.Quantri;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.HOAGIAI
{
	public partial class ThongBaoLuaChonHG : System.Web.UI.Page
	{
		private string pathTemplateWord = ConfigurationManager.AppSettings["TemplateWordSTPT"];
		private GSTPContext dt = new GSTPContext();
		private QT_FILE_BL fileHelper = new QT_FILE_BL();
		private HOAGIAI_BL _hoaGiaiBl = new HOAGIAI_BL();
		private static CultureInfo cul = new CultureInfo("vi-VN");
		public Decimal loaiAn = 0;
		public Decimal vuViecId = 0;
		public bool isUpdateAction = true;
		public string hoagiaitext = "hoà giải";
		public string black = "color: black;";
		public string gray = "color: gray;";
		public string ngaytext = "Ngày đương sự trả lời";

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
				loaddllLoaiThongBao();
				this.LoadDdlNguoiKy();
				loadChkDuongSu(0);
				LoadGrid();
			}
		}

		public bool checkQuyen()
		{
			loaiAn = Convert.ToDecimal(hddLoaiAn.Value);
			vuViecId = Convert.ToDecimal(hddVuViecId.Value);

			var checkPCTPQGD = _hoaGiaiBl.CheckPCTPQGD(this.vuViecId, this.loaiAn);
			if (checkPCTPQGD)
			{
				Cls_Comon.SetButton(btnUpdate, true);
			}
			else
			{
				Cls_Comon.SetButton(btnUpdate, false);
				hddShowCommand.Value = "False";
				lblThongBao.Text = "Vụ việc đã được phân công thẩm phán giải quyết đơn. Không được sửa!";
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
			var pctp = DataExtensions.GetAllWithClause<HOAGIAI_THAMPHAN>($"HOAGIAIID = {hoaGiaiDon.ID}").FirstOrDefault();
			if (pctp != null)
			{
				Cls_Comon.SetButton(btnUpdate, false);
				hddShowCommand.Value = "False";
				lblThongBao.Text = "Vụ việc đã được phân công. Không được sửa!";
				return false;
			}
			return true;
		}

		public void LoadDdlNguoiKy()
		{
			DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
			System.Data.DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_3CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA, ENUM_CHUCVU.TP);
			ddlNguoiKy.DataSource = oCBDT;
			ddlNguoiKy.DataTextField = "MA_TEN";
			ddlNguoiKy.DataValueField = "ID";
			ddlNguoiKy.DataBind();
			//ddlNguoiKy.Items.Insert(0, "----Chọn----");
		}

		public void loaddllLoaiThongBao()
		{
			dllLoaiThongBao.Items.Clear();
			dllLoaiThongBao.Items.Add(new ListItem() { Value = "0", Text = $"Thông báo về quyền lựa chọn {hoagiaitext} và lựa chọn hoà giải viên" });
		}

		public void loadChkDuongSu(decimal thongBaoId)
		{
			var tbl = _hoaGiaiBl.GetDuongSuThongBao(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, V_THONGBAOID: 0);
			chkDuongSu.DataSource = tbl;
			chkDuongSu.DataTextField = "TENDUONGSU";
			chkDuongSu.DataValueField = "ID";
			chkDuongSu.DataBind();
			if (thongBaoId > 0)
			{
				List<HOAGIAI_THONGBAO_DUONGSU> duongSus = DataExtensions.GetAllWithClause<HOAGIAI_THONGBAO_DUONGSU>($"THONGBAOID = {thongBaoId}");
				if (duongSus != null && duongSus.Count > 0)
				{
					var lstID = duongSus.Select(x => x.DUONGSUID).ToList();
					foreach (ListItem i in chkDuongSu.Items)
					{
						decimal HTID = Convert.ToDecimal(i.Value);
						if (lstID.Contains(Convert.ToDecimal(i.Value)))
							i.Selected = true;
					}
					hddlstDuongSuId.Value = String.Join(",", lstID);
				}
			}
		}

		public void LoadGrid()
		{
			HOAGIAI_BL _hoaGiaiBl = new HOAGIAI_BL();
			System.Data.DataTable oDT = _hoaGiaiBl.GETLIST_THONGBAO(Convert.ToDecimal(hddHoaGiaiId.Value), Convert.ToDecimal(hddLoaiAn.Value));
			if (oDT != null && oDT.Rows.Count > 0)
			{
				dgList.DataSource = oDT;
				dgList.DataBind();
				pndata.Visible = true;
			}
			else
			{
				pndata.Visible = false;
			}
		}

		private void rdbKqTrueFalse(ListItem radioButton, bool en)
		{
			radioButton.Enabled = en;
			radioButton.Attributes.Add("style", en ? this.black : this.gray);
		}

		protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
		{
			decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
			switch (e.CommandName)
			{
				case "Download":
					decimal FileID = Convert.ToDecimal(ND_id);
					QT_FILE fileSR = DataExtensions.FindById<QT_FILE>(FileID);
					if (fileSR != null)
					{
						var cacheKey = Guid.NewGuid().ToString("N");
						var NOIDUNG = fileHelper.GetNoiDungFile(fileSR, Convert.ToInt32(hddLoaiAn.Value));
						Context.Cache.Insert(key: cacheKey, value: NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
						ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + fileSR.FILE_NAME + "&Extension=" + fileSR.FILE_TYPE + "';", true);
					}
					break;
				//case "DownloadBM":
				//    HOAGIAI_THONGBAO thongBao = DataExtensions.FindById<HOAGIAI_THONGBAO>(ND_id);
				//    if (thongBao == null)
				//        return;
				//    string fileNameSave = "";
				//    if (hddLoaiAn.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)
				//    {
				//        if (thongBao.SOLAN == 1)
				//        {
				//            fileNameSave = $"r01_DT_{DateTime.Now.ToString("yyyy_dd_MM_HH_mm_ss")}.doc";
				//            DownloadR01_HG(thongBao, fileNameSave);
				//        }
				//        else if (thongBao.SOLAN == 2)
				//        {
				//            fileNameSave = $"r02_DT_{DateTime.Now.ToString("yyyy_dd_MM_HH_mm_ss")}.doc";
				//            DownloadR02_HG(thongBao, fileNameSave);
				//        }
				//    }
				//    else
				//    {
				//        if (thongBao.SOLAN == 1)
				//        {
				//            fileNameSave = $"r01_HG_{DateTime.Now.ToString("yyyy_dd_MM_HH_mm_ss")}.doc";
				//            DownloadR01_HG(thongBao, fileNameSave);
				//        }
				//        else if (thongBao.SOLAN == 2)
				//        {
				//            fileNameSave = $"r02_HG_{DateTime.Now.ToString("yyyy_dd_MM_HH_mm_ss")}.doc";
				//            DownloadR02_HG(thongBao, fileNameSave);
				//        }
				//    }

				//    string path = pathTemplateWord + fileNameSave;
				//    if (File.Exists(path))
				//    {
				//        var cacheKeyBM = Guid.NewGuid().ToString("N");
				//        var _byte = File.ReadAllBytes(path);
				//        //var NOIDUNG = fileHelper.GetNoiDungFile(_byte, Convert.ToInt32(hddLoaiAn.Value));
				//        Context.Cache.Insert(key: cacheKeyBM, value: _byte, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
				//        string fileName = System.IO.Path.GetFileNameWithoutExtension(fileNameSave);
				//        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKeyBM + "&FileName=" + fileName + "&Extension=.doc';", true);
				//        File.Delete(path);
				//    }

				//    break;

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
					MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
					if (oPer.XOA == false || btnUpdate.Enabled == false)
					{
						lblThongBao.Text = "Bạn không có quyền xóa!";
						return;
					}
					var item = DataExtensions.FindById<HOAGIAI_THONGBAO>(ND_id);

					#region check kết quả

					var ketquaThongBao = DataExtensions.GetAllWithClause<HOAGIAI_THONGBAO_KETQUA>($"THONGBAOID = {ND_id}");
					if (ketquaThongBao != null && ketquaThongBao.Count > 0)
					{
						lblThongBao.Text = "Đã có kết quả lựa chọn hoà giải. Không được xoá!";
						return;
					}

					#endregion check kết quả

					#region xoá đương sự

					List<HOAGIAI_THONGBAO_DUONGSU> duongSus = DataExtensions.GetAllWithClause<HOAGIAI_THONGBAO_DUONGSU>($"THONGBAOID = {item.ID}");
					if (duongSus != null && duongSus.Count > 0)
					{
						foreach (var itemduongsu in duongSus)
						{
							DataExtensions.Delete(itemduongsu);
						}
					}

					#endregion xoá đương sự

					DataExtensions.Delete(item);
					ResetControls();
					lblThongBao.Text = "Xoá thành công";
					LoadGrid();
					break;
			}
		}

		public void loadedit(decimal id, bool isCapNhat = false)
		{
			HOAGIAI_THONGBAO item = DataExtensions.FindById<HOAGIAI_THONGBAO>(id);
			if (item != null)
			{
				hddid.Value = id.ToString();
				txtSoLan.Text = item.SOLAN + "";
				if (item.NGAYTHONGBAO != null) txtNgayThongBao.Text = ((DateTime)item.NGAYTHONGBAO).ToString("dd/MM/yyyy", cul);
				txtSoThongBao.Text = item.SOTHONGBAO + "";
				try
				{
					ddlNguoiKy.SelectedValue = item.NGUOIKYID?.ToString();
				}
				catch
				{
					ddlNguoiKy.SelectedIndex = 0;
				}
				loadChkDuongSu(item.ID);
				//txtNguoiKy.Text = item.NGUOIKY + "";
				if ((item.FILEID + "") != "" && (item.FILEID + "") != "0")
				{
					HOAGIAI_FILE hgFile = DataExtensions.FindById<HOAGIAI_FILE>(item.FILEID.Value);
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
				ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");


				if (rowView["TENFILE"] + "" == "")
				{
					lblDownload.Visible = false;
				}
				else
				{
					lblDownload.Visible = true;
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
				//    Cls_Comon.SetButton(btnUpdate, true);
				//    lblSua.Text = "Sửa";
				//}
				//else
				//{
				//    lbtXoa.Visible = false;
				//    Cls_Comon.SetButton(btnUpdate, false);
				//    lblSua.Text = "Chi tiết";
				//}
				//if (!Convert.ToBoolean(hddShowCommand.Value))
				//{
				//    lbtXoa.Visible = false;
				//    Cls_Comon.SetButton(btnUpdate, false);
				//    lblSua.Text = "Chi tiết";
				//}
			}
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

		protected void btnUpdate_Click(object sender, EventArgs e)
		{
			lblThongBao.Text = "";
			if (!CheckValid()) return;
			else
			{
				if (this.checkQuyen() == false)
				{
					return;
				}
				decimal id = Convert.ToDecimal(hddid.Value);
				HOAGIAI_THONGBAO item;
				if (id > 0)
					item = DataExtensions.FindById<HOAGIAI_THONGBAO>(id);
				else
					item = new HOAGIAI_THONGBAO();
				item.HOAGIAIID = Convert.ToDecimal(hddHoaGiaiId.Value);
				item.SOLAN = txtSoLan.Text.toNumber();
				item.SOTHONGBAO = txtSoThongBao.Text;
				item.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgayThongBao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayThongBao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
				if (ddlNguoiKy.SelectedValue != null && ddlNguoiKy.SelectedValue != "0")
					item.NGUOIKYID = Convert.ToDecimal(ddlNguoiKy.SelectedValue);

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
						item.FILEID = hgFile.ID;
						File.Delete(strFilePath);
						hddFilePath.Value = "";
					}
					catch (Exception ex) { lblThongBao.Text = ex.Message; }
				}
				bool isAction = false;
				if (item.ID == 0)
				{
					item.NGAYTAO = item.NGAYSUA = DateTime.Now;
					item.NGUOITAO = item.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
					decimal isInsert = DataExtensions.Insert(item);
					if (isInsert != 0)
					{
						isAction = true;
					}
				}
				else
				{
					item.NGAYSUA = DateTime.Now;
					item.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
					isAction = DataExtensions.Update(item);
				}
				if (isAction)
				{
					#region update đương sự

					if (hddlstDuongSuId.Value != "")
					{
						var lstID = hddlstDuongSuId.Value.Split(',').Select(x => Convert.ToDecimal(x)).ToList();
						List<HOAGIAI_THONGBAO_DUONGSU> duongSus = DataExtensions.GetAllWithClause<HOAGIAI_THONGBAO_DUONGSU>($"THONGBAOID = {item.ID}");
						if (duongSus != null && duongSus.Count > 0)
						{
							var lstDSID = duongSus.Select(x => x.DUONGSUID).ToList();
							var lstAdd = lstID.Where(x => !lstDSID.Contains(x)).ToList();
							var lstDel = lstDSID.Where(x => !lstID.Contains(x)).ToList();
							if (lstID == null || lstID.Count == 0)
								lstDel = lstDSID;
							if (lstDel != null)
							{
								foreach (var idDel in lstDel)
								{
									var itemDel = duongSus.Where(x => x.DUONGSUID == idDel).FirstOrDefault();
									if (itemDel != null)
										DataExtensions.Delete(itemDel);
								}
							}
							if (lstAdd != null)
							{
								foreach (var idAdd in lstAdd)
								{
									HOAGIAI_THONGBAO_DUONGSU itemAdd = new HOAGIAI_THONGBAO_DUONGSU()
									{
										HOAGIAIID = item.HOAGIAIID,
										THONGBAOID = item.ID,
										LOAIANID = loaiAn,
										DUONGSUID = idAdd
									};
									DataExtensions.Insert(itemAdd);
								}
							}
						}
						else
						{
							foreach (var idAdd in lstID)
							{
								HOAGIAI_THONGBAO_DUONGSU itemAdd = new HOAGIAI_THONGBAO_DUONGSU()
								{
									HOAGIAIID = item.HOAGIAIID,
									THONGBAOID = item.ID,
									LOAIANID = loaiAn,
									DUONGSUID = idAdd
								};
								DataExtensions.Insert(itemAdd);
							}
						}
					}

					#endregion update đương sự

					ResetControls();
					LoadGrid();
					lblThongBao.Text = "Lưu thành công";
					//this.btnLammoi_Click(null, null);
				}
				else
				{
					lblThongBao.Text = "Có lỗi trong quá trình xử lý";
					return;
				}
			}
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

		private bool CheckValid()
		{
			if (String.IsNullOrEmpty(txtSoLan.Text))
			{
				lblThongBao.Text = "Chưa nhập số lần thông báo.";
				txtSoLan.Focus();
				return false;
			}
			if (String.IsNullOrEmpty(hddlstDuongSuId.Value))
			{
				lblThongBao.Text = "Chưa chọn đương sự.";
				chkDuongSu.Focus();
				return false;
			}

			if (String.IsNullOrEmpty(txtSoThongBao.Text))
			{
				lblThongBao.Text = "Chưa nhập số thông báo.";
				txtSoThongBao.Focus();
				return false;
			}
			else if (txtSoThongBao.Text.Trim().Length >= 20)
			{
				lblThongBao.Text = "Số thông báo nhập quá dài.";
				txtSoThongBao.Focus();
				return false;
			}

			#region txtNgayThongBao

			if (String.IsNullOrEmpty(txtNgayThongBao.Text))
			{
				lblThongBao.Text = "Bạn chưa nhập ngày thông báo !";
				txtNgayThongBao.Focus();
				return false;
			}
			else
			{
				if (Cls_Comon.IsValidDate(txtNgayThongBao.Text) == false)
				{
					lblThongBao.Text = "Bạn chưa nhập ngày thông báo theo định dạng (dd/MM/yyyy) !";
					txtNgayThongBao.Focus();
					return false;
				}

				DateTime NgayThongBao = DateTime.Parse(txtNgayThongBao.Text, cul, DateTimeStyles.NoCurrentDateDefault);

				if (NgayThongBao > DateTime.Now)
				{
					lblThongBao.Text = "Ngày giao phải trước ngày hiện tại !";
					txtNgayThongBao.Focus();
					return false;
				}
			}

			#endregion txtNgayThongBao

			return true;
		}

		protected void btnLammoi_Click(object sender, EventArgs e)
		{
			ResetControls();
		}

		private void ResetControls()
		{
			lblThongBao.Text =txtSoLan.Text = txtNgayThongBao.Text = "";
			ddlNguoiKy.SelectedIndex = 0;
			hddFilePath.Value = "";
			hddid.Value = "0";
			lbtDownload.Text = "";
			lbtDownload.Visible = false;
			checkQuyen();
			txtSoThongBao.Text = "";
			loadChkDuongSu(0);
		}

		#region in biểu mẫu

		public void DownLoadBieuMau(decimal ID)
		{
		}

		#region load biểu mẫu

		//public void DownloadR01_HG(HOAGIAI_THONGBAO thongBao, string fileNameSave)
		//{
		//    decimal vDonID = Convert.ToDecimal(hddVuViecId.Value);
		//    string loaiAn = hddLoaiAn.Value.ToString();
		//    r01_HG report = new r01_HG();
		//    decimal toaAnId = 0;
		//    switch (loaiAn)
		//    {
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
		//            ADS_DON oDon = dt.ADS_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDon == null || (oDon != null && oDon.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDon.TOAANID;
		//            //if (oDon.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDon.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDon.TENVUVIEC;
		//            ADS_DON_DUONGSU duongSu = dt.ADS_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSu != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSu.GIOITINH.GetValueOrDefault(0)) + " " + duongSu.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSu.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSu.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSu.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSu.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSu.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
		//            AHC_DON oDonHC = dt.AHC_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonHC == null || (oDonHC != null && oDonHC.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonHC.TOAANID;
		//            //if (oDon.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDon.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonHC.TENVUVIEC;
		//            AHC_DON_DUONGSU duongSuHC = dt.AHC_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuHC != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuHC.GIOITINH.GetValueOrDefault(0)) + " " + duongSuHC.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuHC.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuHC.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuHC.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuHC.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuHC.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
		//            AHN_DON oDonHN = dt.AHN_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonHN == null || (oDonHN != null && oDonHN.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonHN.TOAANID;
		//            //if (oDon.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDon.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonHN.TENVUVIEC;
		//            AHN_DON_DUONGSU duongSuHN = dt.AHN_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuHN != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuHN.GIOITINH.GetValueOrDefault(0)) + " " + duongSuHN.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuHN.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuHN.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuHN.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuHN.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuHN.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
		//            ALD_DON oDonLD = dt.ALD_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonLD == null || (oDonLD != null && oDonLD.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonLD.TOAANID;
		//            //if (oDonLD.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDonLD.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonLD.TENVUVIEC;
		//            ALD_DON_DUONGSU duongSuLD = dt.ALD_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuLD != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuLD.GIOITINH.GetValueOrDefault(0)) + " " + duongSuLD.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuLD.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuLD.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuLD.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuLD.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuLD.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;

		//        case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
		//            AKT_DON oDonKT = dt.AKT_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonKT == null || (oDonKT != null && oDonKT.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonKT.TOAANID;
		//            //if (oDonKT.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDonKT.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonKT.TENVUVIEC;
		//            AKT_DON_DUONGSU duongSuKT = dt.AKT_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuKT != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuKT.GIOITINH.GetValueOrDefault(0)) + " " + duongSuKT.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuKT.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuKT.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuKT.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuKT.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuKT.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//    }
		//    DM_TOAAN toaHienTai = dt.DM_TOAAN.Where(x => x.ID == toaAnId).FirstOrDefault();

		//    report.TOA_RA_THONGBAO = report.TOA_HIEN_TAI = toaHienTai.TEN.Replace("Tòa án nhân dân", "TAND");
		//    if (toaHienTai.LOAITOA == "CAPHUYEN")
		//    {
		//        report.TOA_RA_THONGBAO = report.TOA_RA_THONGBAO + " hoặc Tòa án cấp huyện khác trên cùng phạm vi địa giới hành chính với Tòa án nhân dân cấp tỉnh để tiến hành hòa giải đối với vụ việc nêu trên.Trường hợp lựa chọn Hòa giải viên trong danh sách Hòa giải viên thuộc Tòa án cấp huyện khác với Tòa án nơi tiến hành hòa giải thì phải có sự đồng ý của Hòa giải viên được lựa chọn và Tòa án nơi Hòa giải viên đó làm việc";
		//        DM_TOAAN toaCapTren = dt.DM_TOAAN.Where(x => x.ID == toaHienTai.CAPCHAID).FirstOrDefault();
		//        if (toaCapTren != null)
		//            report.TOA_CAP_TREN = toaCapTren.TEN.Replace("Tòa án nhân dân", "TAND");
		//    }
		//    else if (toaHienTai.LOAITOA == "CAPTINH")
		//    {
		//        report.TOA_CAP_TREN = "TAND tối cao";
		//    }

		//    report.SO_THONG_BAO = thongBao.SOTHONGBAO;

		//    report.TOA_HIEN_TAI_DIACHI = (toaHienTai.DIACHI ?? "").PadRight(25, ' ');
		//    report.TOA_HIEN_TAI_FAX = (toaHienTai.FAX ?? "").PadRight(20, ' ');
		//    report.TOA_HIEN_TAI_MAIL = (toaHienTai.EMAIL ?? "").PadRight(20, ' ');
		//    report.NAM = DateTime.Now.Year.ToString();
		//    report.NGAY = DateTime.Now.Day.ToString();
		//    report.THANG = DateTime.Now.Month.ToString();
		//    report.NGUOI_KY = thongBao.NGUOIKY;

		//    DM_HANHCHINH dvHanhChinh = dt.DM_HANHCHINH.Where(x => x.ID == toaHienTai.HANHCHINHID).FirstOrDefault();
		//    if (dvHanhChinh != null)
		//        report.DIACHI = char.ToUpper(dvHanhChinh.TEN[0]) + dvHanhChinh.TEN.Substring(1);

		//    string fileName = pathTemplateWord + "r01_HG.doc";

		//    string saveAs = pathTemplateWord + fileNameSave;
		//    Document baoCao = new Document(fileName);
		//    baoCao.MailMerge.Execute(new[] { "TOA_CAP_TREN" }, new[] { report.TOA_CAP_TREN });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI" }, new[] { report.TOA_HIEN_TAI });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI_DIACHI" }, new[] { report.TOA_HIEN_TAI_DIACHI });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI_MAIL" }, new[] { report.TOA_HIEN_TAI_MAIL });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI_FAX" }, new[] { report.TOA_HIEN_TAI_FAX });
		//    baoCao.MailMerge.Execute(new[] { "SO_THONG_BAO" }, new[] { report.SO_THONG_BAO });
		//    baoCao.MailMerge.Execute(new[] { "DIACHI" }, new[] { report.DIACHI });
		//    baoCao.MailMerge.Execute(new[] { "NGAY" }, new[] { report.NGAY });
		//    baoCao.MailMerge.Execute(new[] { "THANG" }, new[] { report.THANG });
		//    baoCao.MailMerge.Execute(new[] { "NAM" }, new[] { report.NAM });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN" }, new[] { report.NGUOI_NHAN });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_DIACHI" }, new[] { report.NGUOI_NHAN_DIACHI });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_SDT" }, new[] { report.NGUOI_NHAN_SDT });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_FAX" }, new[] { report.NGUOI_NHAN_FAX });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_MAIL" }, new[] { report.NGUOI_NHAN_MAIL });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_XUNGHO" }, new[] { report.NGUOI_NHAN_XUNGHO });
		//    baoCao.MailMerge.Execute(new[] { "TEN_QHPL" }, new[] { report.TEN_QHPL });
		//    baoCao.MailMerge.Execute(new[] { "TOA_RA_THONGBAO" }, new[] { report.TOA_RA_THONGBAO });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_KY" }, new[] { report.NGUOI_KY });
		//    baoCao.Save(saveAs);
		//    //ExportData(fileNameSave, (string)saveAs);
		//    //File.Delete(saveAs);
		//}
		//public void DownloadR02_HG(HOAGIAI_THONGBAO thongBao, string fileNameSave)
		//{
		//    decimal vDonID = Convert.ToDecimal(hddVuViecId.Value);
		//    string loaiAn = hddLoaiAn.Value.ToString();

		//    r02_HG report = new r02_HG();
		//    decimal toaAnId = 0;
		//    switch (loaiAn)
		//    {
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
		//            ADS_DON oDon = dt.ADS_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDon == null || (oDon != null && oDon.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDon.TOAANID;
		//            //if (oDon.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDon.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDon.TENVUVIEC;
		//            ADS_DON_DUONGSU duongSu = dt.ADS_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSu != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSu.GIOITINH.GetValueOrDefault(0)) + " " + duongSu.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSu.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSu.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSu.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSu.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSu.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
		//            AHC_DON oDonHC = dt.AHC_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonHC == null || (oDonHC != null && oDonHC.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonHC.TOAANID;
		//            //if (oDon.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDon.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonHC.TENVUVIEC;
		//            AHC_DON_DUONGSU duongSuHC = dt.AHC_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuHC != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuHC.GIOITINH.GetValueOrDefault(0)) + " " + duongSuHC.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuHC.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuHC.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuHC.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuHC.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuHC.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
		//            AHN_DON oDonHN = dt.AHN_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonHN == null || (oDonHN != null && oDonHN.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonHN.TOAANID;
		//            //if (oDon.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDon.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonHN.TENVUVIEC;
		//            AHN_DON_DUONGSU duongSuHN = dt.AHN_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuHN != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuHN.GIOITINH.GetValueOrDefault(0)) + " " + duongSuHN.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuHN.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuHN.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuHN.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuHN.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuHN.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
		//            ALD_DON oDonLD = dt.ALD_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonLD == null || (oDonLD != null && oDonLD.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonLD.TOAANID;
		//            //if (oDonLD.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDonLD.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonLD.TENVUVIEC;
		//            ALD_DON_DUONGSU duongSuLD = dt.ALD_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuLD != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuLD.GIOITINH.GetValueOrDefault(0)) + " " + duongSuLD.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuLD.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuLD.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuLD.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuLD.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuLD.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;

		//        case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
		//            AKT_DON oDonKT = dt.AKT_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonKT == null || (oDonKT != null && oDonKT.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonKT.TOAANID;
		//            //if (oDonKT.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDonKT.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonKT.TENVUVIEC;
		//            AKT_DON_DUONGSU duongSuKT = dt.AKT_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuKT != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuKT.GIOITINH.GetValueOrDefault(0)) + " " + duongSuKT.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuKT.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuKT.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuKT.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuKT.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuKT.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;

		//    }
		//    DM_TOAAN toaHienTai = dt.DM_TOAAN.Where(x => x.ID == toaAnId).FirstOrDefault();

		//    report.TOA_RA_THONGBAO = report.TOA_HIEN_TAI = toaHienTai.TEN.Replace("Tòa án nhân dân", "TAND");
		//    if (toaHienTai.LOAITOA == "CAPHUYEN")
		//    {
		//        report.TOA_RA_THONGBAO = report.TOA_RA_THONGBAO + " hoặc Tòa án cấp huyện khác trên cùng phạm vi địa giới hành chính với Tòa án nhân dân cấp tỉnh để tiến hành hòa giải đối với vụ việc nêu trên.Trường hợp lựa chọn Hòa giải viên trong danh sách Hòa giải viên thuộc Tòa án cấp huyện khác với Tòa án nơi tiến hành hòa giải thì phải có sự đồng ý của Hòa giải viên được lựa chọn và Tòa án nơi Hòa giải viên đó làm việc";
		//        DM_TOAAN toaCapTren = dt.DM_TOAAN.Where(x => x.ID == toaHienTai.CAPCHAID).FirstOrDefault();
		//        if (toaCapTren != null)
		//            report.TOA_CAP_TREN = toaCapTren.TEN.Replace("Tòa án nhân dân", "TAND");
		//    }
		//    else if (toaHienTai.LOAITOA == "CAPTINH")
		//    {
		//        report.TOA_CAP_TREN = "TAND tối cao";
		//    }

		//    report.SO_THONG_BAO = thongBao.SOTHONGBAO;

		//    report.TOA_HIEN_TAI_DIACHI = (toaHienTai.DIACHI ?? "").PadRight(25, ' ');
		//    report.TOA_HIEN_TAI_FAX = (toaHienTai.FAX ?? "").PadRight(20, ' ');
		//    report.TOA_HIEN_TAI_MAIL = (toaHienTai.EMAIL ?? "").PadRight(20, ' ');
		//    report.NAM = DateTime.Now.Year.ToString();
		//    report.NGAY = DateTime.Now.Day.ToString();
		//    report.THANG = DateTime.Now.Month.ToString();
		//    report.NGUOI_KY = thongBao.NGUOIKY;
		//    DM_HANHCHINH dvHanhChinh = dt.DM_HANHCHINH.Where(x => x.ID == toaHienTai.HANHCHINHID).FirstOrDefault();
		//    if (dvHanhChinh != null)
		//        report.DIACHI = char.ToUpper(dvHanhChinh.TEN[0]) + dvHanhChinh.TEN.Substring(1);

		//    string fileName = pathTemplateWord + "r02_HG.doc";

		//    string saveAs = pathTemplateWord + fileNameSave;
		//    Document baoCao = new Document(fileName);
		//    baoCao.MailMerge.Execute(new[] { "TOA_CAP_TREN" }, new[] { report.TOA_CAP_TREN });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI" }, new[] { report.TOA_HIEN_TAI });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI_DIACHI" }, new[] { report.TOA_HIEN_TAI_DIACHI });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI_MAIL" }, new[] { report.TOA_HIEN_TAI_MAIL });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI_FAX" }, new[] { report.TOA_HIEN_TAI_FAX });
		//    baoCao.MailMerge.Execute(new[] { "SO_THONG_BAO" }, new[] { report.SO_THONG_BAO });
		//    baoCao.MailMerge.Execute(new[] { "DIACHI" }, new[] { report.DIACHI });
		//    baoCao.MailMerge.Execute(new[] { "NGAY" }, new[] { report.NGAY });
		//    baoCao.MailMerge.Execute(new[] { "THANG" }, new[] { report.THANG });
		//    baoCao.MailMerge.Execute(new[] { "NAM" }, new[] { report.NAM });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN" }, new[] { report.NGUOI_NHAN });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_DIACHI" }, new[] { report.NGUOI_NHAN_DIACHI });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_SDT" }, new[] { report.NGUOI_NHAN_SDT });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_FAX" }, new[] { report.NGUOI_NHAN_FAX });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_MAIL" }, new[] { report.NGUOI_NHAN_MAIL });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_XUNGHO" }, new[] { report.NGUOI_NHAN_XUNGHO });
		//    baoCao.MailMerge.Execute(new[] { "TEN_QHPL" }, new[] { report.TEN_QHPL });
		//    baoCao.MailMerge.Execute(new[] { "TOA_RA_THONGBAO" }, new[] { report.TOA_RA_THONGBAO });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_KY" }, new[] { report.NGUOI_KY });
		//    baoCao.Save(saveAs);
		//    //ExportData(fileNameSave, (string)saveAs);
		//    //File.Delete(saveAs);
		//}
		//public void DownloadR01_DT(HOAGIAI_THONGBAO thongBao, string fileNameSave)
		//{
		//    decimal vDonID = Convert.ToDecimal(hddVuViecId.Value);
		//    string loaiAn = hddLoaiAn.Value.ToString();
		//    r01_DT report = new r01_DT();
		//    decimal toaAnId = 0;
		//    switch (loaiAn)
		//    {
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
		//            ADS_DON oDon = dt.ADS_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDon == null || (oDon != null && oDon.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDon.TOAANID;
		//            //if (oDon.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDon.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDon.TENVUVIEC;
		//            ADS_DON_DUONGSU duongSu = dt.ADS_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSu != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSu.GIOITINH.GetValueOrDefault(0)) + " " + duongSu.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSu.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSu.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSu.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSu.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSu.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
		//            AHC_DON oDonHC = dt.AHC_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonHC == null || (oDonHC != null && oDonHC.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonHC.TOAANID;
		//            //if (oDon.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDon.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonHC.TENVUVIEC;
		//            AHC_DON_DUONGSU duongSuHC = dt.AHC_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuHC != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuHC.GIOITINH.GetValueOrDefault(0)) + " " + duongSuHC.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuHC.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuHC.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuHC.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuHC.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuHC.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
		//            AHN_DON oDonHN = dt.AHN_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonHN == null || (oDonHN != null && oDonHN.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonHN.TOAANID;
		//            //if (oDon.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDon.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonHN.TENVUVIEC;
		//            AHN_DON_DUONGSU duongSuHN = dt.AHN_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuHN != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuHN.GIOITINH.GetValueOrDefault(0)) + " " + duongSuHN.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuHN.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuHN.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuHN.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuHN.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuHN.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
		//            ALD_DON oDonLD = dt.ALD_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonLD == null || (oDonLD != null && oDonLD.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonLD.TOAANID;
		//            //if (oDonLD.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDonLD.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonLD.TENVUVIEC;
		//            ALD_DON_DUONGSU duongSuLD = dt.ALD_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuLD != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuLD.GIOITINH.GetValueOrDefault(0)) + " " + duongSuLD.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuLD.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuLD.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuLD.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuLD.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuLD.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;

		//        case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
		//            AKT_DON oDonKT = dt.AKT_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonKT == null || (oDonKT != null && oDonKT.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonKT.TOAANID;
		//            //if (oDonKT.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDonKT.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonKT.TENVUVIEC;
		//            AKT_DON_DUONGSU duongSuKT = dt.AKT_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuKT != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuKT.GIOITINH.GetValueOrDefault(0)) + " " + duongSuKT.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuKT.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuKT.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuKT.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuKT.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuKT.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//    }
		//    DM_TOAAN toaHienTai = dt.DM_TOAAN.Where(x => x.ID == toaAnId).FirstOrDefault();

		//    report.TOA_RA_THONGBAO = report.TOA_HIEN_TAI = toaHienTai.TEN.Replace("Tòa án nhân dân", "TAND");
		//    if (toaHienTai.LOAITOA == "CAPHUYEN")
		//    {
		//        report.TOA_RA_THONGBAO = report.TOA_RA_THONGBAO + " hoặc Tòa án cấp huyện khác trên cùng phạm vi địa giới hành chính với Tòa án nhân dân cấp tỉnh để tiến hành hòa giải đối với vụ việc nêu trên.Trường hợp lựa chọn Hòa giải viên trong danh sách Hòa giải viên thuộc Tòa án cấp huyện khác với Tòa án nơi tiến hành hòa giải thì phải có sự đồng ý của Hòa giải viên được lựa chọn và Tòa án nơi Hòa giải viên đó làm việc";
		//        DM_TOAAN toaCapTren = dt.DM_TOAAN.Where(x => x.ID == toaHienTai.CAPCHAID).FirstOrDefault();
		//        if (toaCapTren != null)
		//            report.TOA_CAP_TREN = toaCapTren.TEN.Replace("Tòa án nhân dân", "TAND");
		//    }
		//    else if (toaHienTai.LOAITOA == "CAPTINH")
		//    {
		//        report.TOA_CAP_TREN = "TAND tối cao";
		//    }

		//    report.SO_THONG_BAO = thongBao.SOTHONGBAO;

		//    report.TOA_HIEN_TAI_DIACHI = (toaHienTai.DIACHI ?? "").PadRight(25, ' ');
		//    report.TOA_HIEN_TAI_FAX = (toaHienTai.FAX ?? "").PadRight(20, ' ');
		//    report.TOA_HIEN_TAI_MAIL = (toaHienTai.EMAIL ?? "").PadRight(20, ' ');
		//    report.NAM = DateTime.Now.Year.ToString();
		//    report.NGAY = DateTime.Now.Day.ToString();
		//    report.THANG = DateTime.Now.Month.ToString();
		//    report.NGUOI_KY = thongBao.NGUOIKY;

		//    DM_HANHCHINH dvHanhChinh = dt.DM_HANHCHINH.Where(x => x.ID == toaHienTai.HANHCHINHID).FirstOrDefault();
		//    if (dvHanhChinh != null)
		//        report.DIACHI = char.ToUpper(dvHanhChinh.TEN[0]) + dvHanhChinh.TEN.Substring(1);

		//    string fileName = pathTemplateWord + "r01_DT.doc";

		//    string saveAs = pathTemplateWord + fileNameSave;
		//    Document baoCao = new Document(fileName);
		//    baoCao.MailMerge.Execute(new[] { "TOA_CAP_TREN" }, new[] { report.TOA_CAP_TREN });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI" }, new[] { report.TOA_HIEN_TAI });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI_DIACHI" }, new[] { report.TOA_HIEN_TAI_DIACHI });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI_MAIL" }, new[] { report.TOA_HIEN_TAI_MAIL });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI_FAX" }, new[] { report.TOA_HIEN_TAI_FAX });
		//    baoCao.MailMerge.Execute(new[] { "SO_THONG_BAO" }, new[] { report.SO_THONG_BAO });
		//    baoCao.MailMerge.Execute(new[] { "DIACHI" }, new[] { report.DIACHI });
		//    baoCao.MailMerge.Execute(new[] { "NGAY" }, new[] { report.NGAY });
		//    baoCao.MailMerge.Execute(new[] { "THANG" }, new[] { report.THANG });
		//    baoCao.MailMerge.Execute(new[] { "NAM" }, new[] { report.NAM });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN" }, new[] { report.NGUOI_NHAN });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_DIACHI" }, new[] { report.NGUOI_NHAN_DIACHI });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_SDT" }, new[] { report.NGUOI_NHAN_SDT });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_FAX" }, new[] { report.NGUOI_NHAN_FAX });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_MAIL" }, new[] { report.NGUOI_NHAN_MAIL });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_XUNGHO" }, new[] { report.NGUOI_NHAN_XUNGHO });
		//    baoCao.MailMerge.Execute(new[] { "TEN_QHPL" }, new[] { report.TEN_QHPL });
		//    baoCao.MailMerge.Execute(new[] { "TOA_RA_THONGBAO" }, new[] { report.TOA_RA_THONGBAO });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_KY" }, new[] { report.NGUOI_KY });
		//    baoCao.Save(saveAs);
		//    //ExportData(fileNameSave, (string)saveAs);
		//    //File.Delete(saveAs);
		//}
		//public void DownloadR02_DT(HOAGIAI_THONGBAO thongBao, string fileNameSave)
		//{
		//    decimal vDonID = Convert.ToDecimal(hddVuViecId.Value);
		//    string loaiAn = hddLoaiAn.Value.ToString();

		//    r02_DT report = new r02_DT();
		//    decimal toaAnId = 0;
		//    switch (loaiAn)
		//    {
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
		//            ADS_DON oDon = dt.ADS_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDon == null || (oDon != null && oDon.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDon.TOAANID;
		//            //if (oDon.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDon.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDon.TENVUVIEC;
		//            ADS_DON_DUONGSU duongSu = dt.ADS_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSu != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSu.GIOITINH.GetValueOrDefault(0)) + " " + duongSu.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSu.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSu.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSu.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSu.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSu.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
		//            AHC_DON oDonHC = dt.AHC_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonHC == null || (oDonHC != null && oDonHC.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonHC.TOAANID;
		//            //if (oDon.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDon.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonHC.TENVUVIEC;
		//            AHC_DON_DUONGSU duongSuHC = dt.AHC_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuHC != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuHC.GIOITINH.GetValueOrDefault(0)) + " " + duongSuHC.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuHC.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuHC.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuHC.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuHC.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuHC.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
		//            AHN_DON oDonHN = dt.AHN_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonHN == null || (oDonHN != null && oDonHN.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonHN.TOAANID;
		//            //if (oDon.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDon.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonHN.TENVUVIEC;
		//            AHN_DON_DUONGSU duongSuHN = dt.AHN_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuHN != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuHN.GIOITINH.GetValueOrDefault(0)) + " " + duongSuHN.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuHN.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuHN.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuHN.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuHN.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuHN.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//        case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
		//            ALD_DON oDonLD = dt.ALD_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonLD == null || (oDonLD != null && oDonLD.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonLD.TOAANID;
		//            //if (oDonLD.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDonLD.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonLD.TENVUVIEC;
		//            ALD_DON_DUONGSU duongSuLD = dt.ALD_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuLD != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuLD.GIOITINH.GetValueOrDefault(0)) + " " + duongSuLD.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuLD.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuLD.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuLD.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuLD.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuLD.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;

		//        case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
		//            AKT_DON oDonKT = dt.AKT_DON.Where(x => x.ID == vDonID).FirstOrDefault();
		//            if (oDonKT == null || (oDonKT != null && oDonKT.HOAGIAI_TRANGTHAI.GetValueOrDefault(0) == 0))
		//                return;
		//            toaAnId = (decimal)oDonKT.TOAANID;
		//            //if (oDonKT.QUANHEPHAPLUATID > 0)
		//            //    report.TEN_QHPL = getDataItem(Convert.ToDecimal(oDonKT.QUANHEPHAPLUATID));
		//            report.TEN_QHPL = oDonKT.TENVUVIEC;
		//            AKT_DON_DUONGSU duongSuKT = dt.AKT_DON_DUONGSU.Where(x => x.ID == thongBao.NGUOINHANID).FirstOrDefault();
		//            if (duongSuKT != null)
		//            {
		//                report.NGUOI_NHAN = ConvertGioiTinhToString(duongSuKT.GIOITINH.GetValueOrDefault(0)) + " " + duongSuKT.TENDUONGSU;
		//                report.NGUOI_NHAN_DIACHI = (duongSuKT.TAMTRUCHITIET ?? "").PadRight(20, ' ');
		//                report.NGUOI_NHAN_SDT = (duongSuKT.DIENTHOAI ?? "").PadRight(30, ' ');
		//                report.NGUOI_NHAN_XUNGHO = ConvertGioiTinhToString(duongSuKT.GIOITINH.GetValueOrDefault(0));
		//                report.NGUOI_NHAN_XUNGHO = report.NGUOI_NHAN_XUNGHO ?? "   ";
		//                report.NGUOI_NHAN_MAIL = (duongSuKT.EMAIL ?? "").PadRight(40, ' ');
		//                report.NGUOI_NHAN_FAX = (duongSuKT.FAX ?? "").PadRight(20, ' ');
		//            }
		//            break;
		//    }
		//    DM_TOAAN toaHienTai = dt.DM_TOAAN.Where(x => x.ID == toaAnId).FirstOrDefault();

		//    report.TOA_RA_THONGBAO = report.TOA_HIEN_TAI = toaHienTai.TEN.Replace("Tòa án nhân dân", "TAND");
		//    if (toaHienTai.LOAITOA == "CAPHUYEN")
		//    {
		//        report.TOA_RA_THONGBAO = report.TOA_RA_THONGBAO + " hoặc Tòa án cấp huyện khác trên cùng phạm vi địa giới hành chính với Tòa án nhân dân cấp tỉnh để tiến hành hòa giải đối với vụ việc nêu trên.Trường hợp lựa chọn Hòa giải viên trong danh sách Hòa giải viên thuộc Tòa án cấp huyện khác với Tòa án nơi tiến hành hòa giải thì phải có sự đồng ý của Hòa giải viên được lựa chọn và Tòa án nơi Hòa giải viên đó làm việc";
		//        DM_TOAAN toaCapTren = dt.DM_TOAAN.Where(x => x.ID == toaHienTai.CAPCHAID).FirstOrDefault();
		//        if (toaCapTren != null)
		//            report.TOA_CAP_TREN = toaCapTren.TEN.Replace("Tòa án nhân dân", "TAND");
		//    }
		//    else if (toaHienTai.LOAITOA == "CAPTINH")
		//    {
		//        report.TOA_CAP_TREN = "TAND tối cao";
		//    }

		//    report.SO_THONG_BAO = thongBao.SOTHONGBAO;

		//    report.TOA_HIEN_TAI_DIACHI = (toaHienTai.DIACHI ?? "").PadRight(25, ' ');
		//    report.TOA_HIEN_TAI_FAX = (toaHienTai.FAX ?? "").PadRight(20, ' ');
		//    report.TOA_HIEN_TAI_MAIL = (toaHienTai.EMAIL ?? "").PadRight(20, ' ');
		//    report.NAM = DateTime.Now.Year.ToString();
		//    report.NGAY = DateTime.Now.Day.ToString();
		//    report.THANG = DateTime.Now.Month.ToString();
		//    report.NGUOI_KY = thongBao.NGUOIKY;
		//    DM_HANHCHINH dvHanhChinh = dt.DM_HANHCHINH.Where(x => x.ID == toaHienTai.HANHCHINHID).FirstOrDefault();
		//    if (dvHanhChinh != null)
		//        report.DIACHI = char.ToUpper(dvHanhChinh.TEN[0]) + dvHanhChinh.TEN.Substring(1);

		//    string fileName = pathTemplateWord + "r02_DT.doc";

		//    string saveAs = pathTemplateWord + fileNameSave;
		//    Document baoCao = new Document(fileName);
		//    baoCao.MailMerge.Execute(new[] { "TOA_CAP_TREN" }, new[] { report.TOA_CAP_TREN });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI" }, new[] { report.TOA_HIEN_TAI });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI_DIACHI" }, new[] { report.TOA_HIEN_TAI_DIACHI });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI_MAIL" }, new[] { report.TOA_HIEN_TAI_MAIL });
		//    baoCao.MailMerge.Execute(new[] { "TOA_HIEN_TAI_FAX" }, new[] { report.TOA_HIEN_TAI_FAX });
		//    baoCao.MailMerge.Execute(new[] { "SO_THONG_BAO" }, new[] { report.SO_THONG_BAO });
		//    baoCao.MailMerge.Execute(new[] { "DIACHI" }, new[] { report.DIACHI });
		//    baoCao.MailMerge.Execute(new[] { "NGAY" }, new[] { report.NGAY });
		//    baoCao.MailMerge.Execute(new[] { "THANG" }, new[] { report.THANG });
		//    baoCao.MailMerge.Execute(new[] { "NAM" }, new[] { report.NAM });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN" }, new[] { report.NGUOI_NHAN });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_DIACHI" }, new[] { report.NGUOI_NHAN_DIACHI });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_SDT" }, new[] { report.NGUOI_NHAN_SDT });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_FAX" }, new[] { report.NGUOI_NHAN_FAX });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_MAIL" }, new[] { report.NGUOI_NHAN_MAIL });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_NHAN_XUNGHO" }, new[] { report.NGUOI_NHAN_XUNGHO });
		//    baoCao.MailMerge.Execute(new[] { "TEN_QHPL" }, new[] { report.TEN_QHPL });
		//    baoCao.MailMerge.Execute(new[] { "TOA_RA_THONGBAO" }, new[] { report.TOA_RA_THONGBAO });
		//    baoCao.MailMerge.Execute(new[] { "NGUOI_KY" }, new[] { report.NGUOI_KY });
		//    baoCao.Save(saveAs);
		//    //ExportData(fileNameSave, (string)saveAs);
		//    //File.Delete(saveAs);
		//}
		private string getDataItem(decimal ItemID)
		{
			try
			{
				DM_DATAITEM oT = dt.DM_DATAITEM.Where(x => x.ID == ItemID).FirstOrDefault();
				return oT.TEN;
			}
			catch { return ""; }
		}

		private string ConvertGioiTinhToString(decimal GioiTinh)
		{
			string re = "Ông";
			if (GioiTinh == 0)
			{
				re = "Bà";
			}
			return re;
		}

		#endregion load biểu mẫu

		#endregion in biểu mẫu

		protected void chkDuongSu_SelectedIndexChanged(object sender, EventArgs e)
		{
			hddlstDuongSuId.Value = "";
			List<decimal> lstSelected = new List<decimal>();
			foreach (ListItem i in chkDuongSu.Items)
			{
				decimal duongSuId = Convert.ToDecimal(i.Value);
				if (i.Selected)
				{
					lstSelected.Add(duongSuId);
				}
			}
			hddlstDuongSuId.Value = String.Join(",", lstSelected);
		}
	}
}