using Aspose.Words;
using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.BIEUMAU.HOAGIAI;
using BL.GSTP.BANGSETGET.HOAGIAI;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.HOAGIAI;
using BL.GSTP.Quantri;
using DAL.GSTP;
using DevExpress.XtraReports.Web.Native;
using Microsoft.Office.Interop.Excel;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows.Shapes;

namespace WEB.GSTP.QLAN.HOAGIAI
{
	public partial class ThongBaoLuaChonHGKQ : System.Web.UI.Page
	{
		string pathTemplateWord = ConfigurationManager.AppSettings["TemplateWordSTPT"];
		GSTPContext dt = new GSTPContext();
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
				LoadDdlThongBao();
				loadddlLuaChon();
				//loadDdlHGV();
				loadDdlNguoiNhan();
				ddlThongBao_SelectedIndexChanged(new object(), new EventArgs());
				LoadGrid();
				loadToaAnHGV();
				ddlToaAnHGV_SelectedIndexChanged(new object(), new EventArgs());
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
            List<HOAGIAI_THONGBAO> tbs = DataExtensions.GetAllWithClause<HOAGIAI_THONGBAO>($"HOAGIAIID = {Convert.ToDecimal(hddHoaGiaiId.Value)}");
            if (tbs.Count== 0)
			{
				Cls_Comon.SetButton(btnUpdate,false);
				hddShowCommand.Value = "False";
				lblThongBao.Text = "Vụ việc chưa có thông báo về quyền lựa chọn hòa giải và lựa chọn hòa giải viên!";
				return false;
            }
			return true;
		}
		public void LoadDdlThongBao()
		{
			List<HOAGIAI_THONGBAO> tbs = DataExtensions.GetAllWithClause<HOAGIAI_THONGBAO>($"HOAGIAIID = {Convert.ToDecimal(hddHoaGiaiId.Value)}");
			
                
			
                ddlThongBao.DataSource = tbs;
                ddlThongBao.DataTextField = "SOTHONGBAO";
                ddlThongBao.DataValueField = "ID";
                ddlThongBao.DataBind();
            if (ddlThongBao.Items.Count == 0)
            {
                ddlThongBao.Items.Add(new ListItem() { Value = "0", Text = "-----Chọn-----" });
            }
            else
            {
                ListItem itemToRemove = ddlThongBao.Items.FindByValue("0");
                ddlThongBao.Items.Remove(itemToRemove);
            }

        }
		public void loadDdlHGV()
		{
            decimal donviId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_TOAAN toaAn = dt.DM_TOAAN.Where(data => data.ID == donviId).FirstOrDefault();
            decimal capchaId = Convert.ToDecimal(toaAn.CAPCHAID);
            DM_TOAAN_BL lsToaAnTrucThuoc = new DM_TOAAN_BL();
            var listhgv = lsToaAnTrucThuoc.GetByCapChaID(capchaId);
            DM_DATAITEM lsData = new DM_DATAITEM();
            lsData = dt.DM_DATAITEM.Where(data => data.MA == ENUM_CHUCDANH.CHUCDANH_HGV).FirstOrDefault();
            decimal cdID = lsData.ID;
            List<DM_CANBO> lsHGV = new List<DM_CANBO>();
            lsHGV = dt.DM_CANBO.Where(ls => ls.CHUCDANHID == cdID).ToList();
            DM_CANBO_BL oDMCBBLHGV = new DM_CANBO_BL();

            foreach (DataRow row in listhgv.Rows)
            {

                var oCBDTHGV = oDMCBBLHGV.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(row["ID"]), ENUM_CHUCDANH.CHUCDANH_HGV);
                foreach (DataRow r in oCBDTHGV.Rows)
                {
                    ddlHGV.Items.Add(new ListItem(r["MA_TEN"].ToString(), r["ID"].ToString()));
                }
            }
        }

		public void loadToaAnHGV()
		{
            ddlToaAnHGV.Items.Clear();
            DM_CANBO_BL oBL = new DM_CANBO_BL();
            DM_TOAAN lsToaAn = new DM_TOAAN();
            decimal donviId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            lsToaAn = dt.DM_TOAAN.Where(data => data.ID == donviId).FirstOrDefault();
            decimal capchaId = Convert.ToDecimal(lsToaAn.CAPCHAID);
            DM_DATAITEM lsData = new DM_DATAITEM();
            lsData = dt.DM_DATAITEM.Where(data => data.MA == ENUM_CHUCDANH.CHUCDANH_HGV).FirstOrDefault();
            decimal cdID = lsData.ID;
            List<DM_CANBO> lsHGV = new List<DM_CANBO>();
            lsHGV = dt.DM_CANBO.Where(ls => ls.CHUCDANHID == cdID).ToList();

            DM_TOAAN_BL lsToaAnTrucThuoc = new DM_TOAAN_BL();
            var listhgv = lsToaAnTrucThuoc.GetByCapChaID(capchaId);
            foreach (DataRow row in listhgv.Rows)
            {
                if (lsHGV.Any(cb => cb.TOAANID == Convert.ToInt32(row["ID"])))
                {
                    ddlToaAnHGV.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
                }
            }
        }
		public void loadddlLuaChon()
		{
			ddlLuaChon.Items.Clear();
			ddlLuaChon.Items.Add(new ListItem() { Value = "1", Text = char.ToUpper(hoagiaitext[0]) + hoagiaitext.Substring(1) });
			ddlLuaChon.Items.Add(new ListItem() { Value = "2", Text = "Không " + hoagiaitext });
			ddlLuaChon.Items.Add(new ListItem() { Value = "3", Text = "Không trả lời" });
			ddlLuaChon.Items.Insert(0, new ListItem("-----Chọn-----", "0"));
			ddlLuaChon.SelectedValue = "0";
			ddlLuaChon_SelectedIndexChanged(new object(), new EventArgs());
		}
		public void loadDdlNguoiNhan(decimal thongBaoId = 0)
		{
			var tbl = _hoaGiaiBl.GetDuongSuThongBao(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, V_THONGBAOID: thongBaoId);
			ddlNguoiNhan.DataSource = tbl;
			ddlNguoiNhan.DataTextField = "TENDUONGSU";
			ddlNguoiNhan.DataValueField = "ID";
			ddlNguoiNhan.DataBind();
		}

		public void LoadGrid()
		{
			HOAGIAI_BL _hoaGiaiBl = new HOAGIAI_BL();
			System.Data.DataTable oDT = _hoaGiaiBl.GETLIST_THONGBAO_KETQUA(Convert.ToDecimal(hddHoaGiaiId.Value), Convert.ToDecimal(hddLoaiAn.Value));
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

		protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
		{
			decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
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
					MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
					if (oPer.XOA == false || btnUpdate.Enabled == false)
					{
						lblThongBao.Text = "Bạn không có quyền xóa!";
						return;
					}
					var item = DataExtensions.FindById<HOAGIAI_THONGBAO_KETQUA>(ND_id);
					DataExtensions.Delete(item);
					HOAGIAI_THONGBAO_KETQUA hgThongBaoCuoi = DataExtensions.GetAllWithClause<HOAGIAI_THONGBAO_KETQUA>($"HOAGIAIID = {Convert.ToDecimal(hddHoaGiaiId.Value)} ORDER BY NGAYTAO DESC").FirstOrDefault();
					if (hgThongBaoCuoi == null)
					{
						this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI);
					}
					else
					{
						#region nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật
						if (hgThongBaoCuoi.LUACHONID == (decimal)ENUM_LUACHON_HOAGIAI.HOAGIAI || hgThongBaoCuoi.LUACHONID == (decimal)ENUM_LUACHON_HOAGIAI.KHONG_TRALOI)
						{
							this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI);
						}
						else if (hgThongBaoCuoi.LUACHONID == (decimal)ENUM_LUACHON_HOAGIAI.KHONG_HOAGIAI)
						{
							this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ENUM_TRANGTHAI_HOAGIAI.THONGBAO_KHONGHOAGIAI);

						}
						#endregion nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật
					}
					Page.Response.Redirect(Page.Request.Url.ToString(), true);
					Context.ApplicationInstance.CompleteRequest();
					lblThongBao.Text = "Lưu thành công";
					//ResetControls();
					//LoadGrid();
					break;
			}
		}

		public void loadedit(decimal id, bool isCapNhat = false)
		{
			HOAGIAI_THONGBAO_KETQUA item = DataExtensions.FindById<HOAGIAI_THONGBAO_KETQUA>(id);
			if (item != null)
			{
				hddid.Value = id.ToString();
				if (item.NGAYDSTRALOI != null) txtNgayDSTraLoi.Text = ((DateTime)item.NGAYDSTRALOI).ToString("dd/MM/yyyy", cul);
				if (item.DUONGSUID > 0)
					ddlNguoiNhan.SelectedValue = item.DUONGSUID.ToString();
				ddlLuaChon.SelectedValue = item.LUACHONID.ToString();
				if (ddlLuaChon.SelectedValue == ((decimal)ENUM_LUACHON_HOAGIAI.HOAGIAI).ToString())
				{
					ngaytext = "Ngày đương sự trả lời";
					pnlCoHoaGiai.Visible = true;
					if (item.HOAGIAIVIENID > 0)
					{
						rdbIsLuaChonHGV.SelectedValue = "1";
						pnlLuaChonHGV.Visible = true;
						ddlToaAnHGV.SelectedValue=item.TOAANHGV.ToString();
						this.ddlToaAnHGV_SelectedIndexChanged(null,null);
						ddlHGV.SelectedValue = item.HOAGIAIVIENID.ToString();
					}
					else
					{
						rdbIsLuaChonHGV.SelectedValue = "0";
						pnlLuaChonHGV.Visible = false;
						ddlHGV.SelectedIndex = 0;
						ddlToaAnHGV.SelectedIndex = 0;
					}
				}
				else if (ddlLuaChon.SelectedValue == ((decimal)ENUM_LUACHON_HOAGIAI.KHONG_TRALOI).ToString())
				{

					ngaytext = "Ngày quá hạn luật định";
					pnlCoHoaGiai.Visible = false;
					item.HOAGIAIVIENID = null;
				}
				else
				{
					ngaytext = "Ngày đương sự trả lời";
					pnlCoHoaGiai.Visible = false;
					item.HOAGIAIVIENID = null;
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

				LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
				Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
				if (this.isUpdateAction)
				{
					lblSua.Text = "Sửa";
				}
				else
				{
					lbtXoa.Visible = false;
					lblSua.Text = "Chi tiết";
				}


			}
		}
		protected void ddlThongBao_SelectedIndexChanged(object sender, EventArgs e)
		{
			if (!String.IsNullOrEmpty(ddlThongBao.SelectedValue) && ddlThongBao.SelectedValue != "0")
			{
				loadDdlNguoiNhan(Convert.ToDecimal(ddlThongBao.SelectedValue));
			}
			else
			{
				loadDdlNguoiNhan();
			}
		}
		protected void ddlLuaChon_SelectedIndexChanged(object sender, EventArgs e)
		{
			if (ddlLuaChon.SelectedValue == ((decimal)ENUM_LUACHON_HOAGIAI.HOAGIAI).ToString())
			{
				pnlCoHoaGiai.Visible = true;
				ngaytext = "Ngày đương sự trả lời";
				rdbIsLuaChonHGV_OnSelectedIndexChanged(new object(), new EventArgs());
			}
			else if (ddlLuaChon.SelectedValue == ((decimal)ENUM_LUACHON_HOAGIAI.KHONG_TRALOI).ToString())
			{

				ngaytext = "Ngày quá hạn luật định";
				pnlCoHoaGiai.Visible = false;
			}
			else
			{
				ngaytext = "Ngày đương sự trả lời";
				pnlCoHoaGiai.Visible = false;
			}
		}

		protected void rdbIsLuaChonHGV_OnSelectedIndexChanged(object sender, EventArgs e)
		{
			if (rdbIsLuaChonHGV.SelectedValue == "1")
				pnlLuaChonHGV.Visible = true;
			else
				pnlLuaChonHGV.Visible = false;
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
				HOAGIAI_THONGBAO_KETQUA item;
				if (id > 0)
					item = DataExtensions.FindById<HOAGIAI_THONGBAO_KETQUA>(id);
				else
					item = new HOAGIAI_THONGBAO_KETQUA();
				item.THONGBAOID = Convert.ToDecimal(ddlThongBao.SelectedValue);
				item.HOAGIAIID = Convert.ToDecimal(hddHoaGiaiId.Value);
				item.LUACHONID = Convert.ToDecimal(ddlLuaChon.SelectedValue);

				if (item.LUACHONID == (decimal)ENUM_LUACHON_HOAGIAI.HOAGIAI)
				{
					if (rdbIsLuaChonHGV.SelectedValue == "1")
					{
						item.TOAANHGV = Convert.ToDecimal(ddlToaAnHGV.SelectedValue);
						item.HOAGIAIVIENID = Convert.ToDecimal(ddlHGV.SelectedValue);
					}

					else
					{
                        item.HOAGIAIVIENID = null;
                        item.TOAANHGV = null;

                    }

                }
				else
				{
					item.HOAGIAIVIENID = null;
					item.TOAANHGV = null;
				}

				item.NGAYDSTRALOI = (String.IsNullOrEmpty(txtNgayDSTraLoi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayDSTraLoi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

				if (ddlNguoiNhan.SelectedValue != "")
				{
					item.DUONGSUID = Convert.ToDecimal(ddlNguoiNhan.SelectedValue);
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
					HOAGIAI_THONGBAO_KETQUA hgTBKhongHG = DataExtensions.GetAllWithClause<HOAGIAI_THONGBAO_KETQUA>($"HOAGIAIID = {item.HOAGIAIID} AND LUACHONID = {(decimal)ENUM_LUACHON_HOAGIAI.KHONG_HOAGIAI}").FirstOrDefault();
					#region nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật
					decimal? TT_HG_DON = this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn);

					if (hgTBKhongHG != null && TT_HG_DON != (decimal)ENUM_TRANGTHAI_HOAGIAI.THONGBAO_KHONGHOAGIAI)
					{
						this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ENUM_TRANGTHAI_HOAGIAI.THONGBAO_KHONGHOAGIAI);
						Page.Response.Redirect(Page.Request.Url.ToString(), true);
						Context.ApplicationInstance.CompleteRequest();
						lblThongBao.Text = "Lưu thành công";
					}
					if (hgTBKhongHG == null && TT_HG_DON != (decimal)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI)
					{
						this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI);
						Page.Response.Redirect(Page.Request.Url.ToString(), true);
						Context.ApplicationInstance.CompleteRequest();
						lblThongBao.Text = "Lưu thành công";
					}
					#endregion nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật
					ResetControls();
					lblThongBao.Text = "Lưu thành công";
					LoadGrid();
					//ResetControls();
					//               LoadGrid();
					//               lblThongBao.Text = "Lưu thành công";
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
			#region ddlNguoiGiao

			if (ddlLuaChon.SelectedValue == "0")
			{
				lblThongBao.Text = "Bạn chưa lựa chọn " + hoagiaitext + ". Hãy chọn lại!";
				ddlLuaChon.Focus();
				return false;
			}

			#endregion ddlNguoiGiao

			#region Nếu chọn hòa giải bắt buộc chọn trường lựa chọn hòa giải viên
			if (ddlLuaChon.SelectedValue == ((decimal)ENUM_LUACHON_HOAGIAI.HOAGIAI).ToString())
			{
				if (rdbIsLuaChonHGV.SelectedIndex == -1)
				{
					lblThongBao.Text = "Bạn chưa chọn hòa giải viên";
					return false;
				}
			}
			#endregion Nếu chọn hòa giải bắt buộc chọn trường lựa chọn hòa giải viên

			return true;
		}

		protected void btnLammoi_Click(object sender, EventArgs e)
		{
			ResetControls();

		}

		private void ResetControls()
		{
			lblThongBao.Text = txtNgayDSTraLoi.Text = "";
			ddlLuaChon.SelectedIndex = 0;
			ddlHGV.SelectedIndex = 0;
			ddlToaAnHGV.SelectedIndex = 0;
			rdbIsLuaChonHGV.SelectedIndex = 0;
			hddid.Value = "0";
			rdbIsLuaChonHGV.SelectedValue = "0";
			pnlLuaChonHGV.Visible = false;
			ddlHGV.SelectedIndex = 0;
			ngaytext = "Ngày đương sự trả lời";
			pnlCoHoaGiai.Visible = false;
			checkQuyen();
		}

        protected void ddlToaAnHGV_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal toaAn = ddlToaAnHGV.SelectedValue.toNumber();
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            System.Data.DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(toaAn, ENUM_CHUCDANH.CHUCDANH_HGV);
            ddlHGV.DataSource = oCBDT;
            ddlHGV.DataTextField = "MA_TEN";
            ddlHGV.DataValueField = "ID";
            ddlHGV.DataBind();
        }
    }
}