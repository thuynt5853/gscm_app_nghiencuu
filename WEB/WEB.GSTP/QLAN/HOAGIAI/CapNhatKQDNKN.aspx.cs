using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.BANGSETGET.HOAGIAI;
using BL.GSTP.BANGSETGET;
using BL.GSTP.HOAGIAI;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.BANGSETGET.QUANTRI;
using DevExpress.XtraPrinting.Native;
using DevExpress.Data.Helpers;
using BL.THONGKE.Info;
using DevExpress.XtraEditors;

namespace WEB.GSTP.QLAN.HOAGIAI
{
	public partial class CapNhatKQDNKN : System.Web.UI.Page
	{
		GSTPContext dt = new GSTPContext();
		CultureInfo cul = new CultureInfo("vi-VN");
		private HOAGIAI_BL _hoaGiaiBl = new HOAGIAI_BL();
		public Decimal loaiAn = 0;
		public Decimal vuViecId = 0;
		public Decimal hoaGiaiID = 0;
		public string hoagiaitext = "hoà giải";
		private bool isUpdateAction = true;
		public decimal textKQ = 0;

		protected void Page_Load(object sender, EventArgs e)
		{
			try
			{
				string strMaCT = Session["MaChuongTrinh"] + "";
				string returnURL = "";
				switch (strMaCT)
				{
					case ENUM_LOAIAN.AN_DANSU:
						loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_DANSU.toNumber();
						returnURL = Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx";
						break;

					case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
						loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH.toNumber();
						returnURL = Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx";
						break;

					case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
						loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI.toNumber();
						returnURL = Cls_Comon.GetRootURL() + "/QLAN/AKT/Hoso/Danhsach.aspx";
						break;

					case ENUM_LOAIAN.AN_LAODONG:
						loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG.toNumber();
						returnURL = Cls_Comon.GetRootURL() + "/QLAN/ALD/Hoso/Danhsach.aspx";
						break;

					case ENUM_LOAIAN.AN_HANHCHINH:
						loaiAn = ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH.toNumber();
						returnURL = Cls_Comon.GetRootURL() + "/QLAN/AHC/Hoso/Danhsach.aspx";
						hoagiaitext = "đối thoại";
						break;

					default:
						returnURL = "/Trangchu.aspx";
						break;
				}
				if (!String.IsNullOrEmpty(hddVuViecID.Value))
					this.vuViecId = Convert.ToDecimal(hddVuViecID.Value);
				if (!String.IsNullOrEmpty(hddHoaGiaiID.Value))
					this.hoaGiaiID = Convert.ToDecimal(hddHoaGiaiID.Value);
				if (!IsPostBack)
				{
					hddPageIndex.Value = "1";
					//this.isUpdateAction = this.checkQuyen();
					LoadGrid();
					this.InitDataForm();
					Cls_Comon.SetButton(cmdGiaiQuyet, false);
				}
			}
			catch (Exception ex) { lbthongbao.Text = ex.Message; }
		}

		private void LoadGrid()
		{
			lbthongbao.Text = "";
			ptT.Visible = ptB.Visible = true;
			if (rdbTrangthai.SelectedValue == "1")
			{
				//Cls_Comon.SetButton(cmdGiaiQuyet, false);
				cmdGiaiQuyet.Text = "Chi tiết";
               
            }
			else
			{
				//Cls_Comon.SetButton(cmdGiaiQuyet, true);
				cmdGiaiQuyet.Text = "Giải quyết";
			}
			decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
			DateTime? dFrom = DateTime.Now;
			DateTime? dTo = DateTime.Now;
			dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
			dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
			HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
			int pageSize = dgList.PageSize, pageIndex = Convert.ToInt32(hddPageIndex.Value);
			DataTable oDT = hoaGiaiBL.GETLIST_VU_VIEC_KQDNKN(
				V_TOALOGIN: vDonViID,
				V_LOAIANID: this.loaiAn,
				V_MAVUVIEC: txtMaVuViec.Text.Trim(),
				V_TENVUVIEC: txtTenVuViec.Text.Trim(),
				V_TUNGAY: dFrom,
				V_DENNGAY: dTo,
				V_TINHTRANG: Convert.ToDecimal(rdbTrangthai.SelectedValue),
				Page_Index: pageIndex, Page_Size: pageSize
				);
			int Total = 0;
			if (oDT != null && oDT.Rows.Count > 0)
			{
				Total = Convert.ToInt32(oDT.Rows[0]["CountAll"]);
				hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
			}
			else
			{
				Cls_Comon.SetButton(cmdGiaiQuyet, false);
			}
			lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
			Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
						 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
			dgList.DataSource = oDT;
			dgList.DataBind();
		}
		protected void cmdGiaiQuyet_Click(object sender, EventArgs e)
		{
			foreach (DataGridItem Item in dgList.Items)
			{
				CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
				if (chkChon.Checked)
				{
					this.OnGiaiQuyet(Item);
					return;
				}
			}
		}
		private void OnGiaiQuyet(DataGridItem Item)
		{
           
            hddVuViecID.Value = Item.Cells[0].Text;
			hddHoaGiaiID.Value = Item.Cells[1].Text;
			string maVuViec = ((Label)Item.FindControl("lblTBMaVuViec")).Text;
			lblMaVuViec.Text = maVuViec;
			string tenVuViec = ((Label)Item.FindControl("lblTBTenVuViec")).Text;
			lblTenVuViec.Text = tenVuViec;
			if (hddVuViecID.Value + "" == "" || hddVuViecID.Value == "0")
			{
				lbthongbao.Text = "Bạn chưa chọn vụ việc để giải quyết. Hãy chọn lại!";
				return;
			}
			else
			{
				this.vuViecId = Convert.ToDecimal(hddVuViecID.Value);
				this.hoaGiaiID = Convert.ToDecimal(hddHoaGiaiID.Value);
            }
			lblThongBao.Text = "";
            HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
            var tbl = hoaGiaiBL.GetAllKetQuaDeNghiKienNghi(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, PageSize: 0, PageIndex: 10);
            foreach (DataRow row in tbl.Rows)
            {
                txtKetQuaDNKNID.Text = row["ID"].ToString();
            }
            string idQDStr = txtKetQuaDNKNID.Text;
			decimal idQD = 0;
            if (!String.IsNullOrEmpty(idQDStr))
            {
                idQD = Convert.ToDecimal(idQDStr);
            }
            HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDNKN = new HOAGIAI_DENGHI_KIENNGHI_KETQUA();
            if (idQD != 0)
            {
                kqDNKN = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(idQD);
			}
			else
			{
				lblThongBao.Text = "Chưa nhập thông tin thụ lý";
				lblThongBaoKQ.Text = "Chưa nhập kết quả";
			}
            txtKetQuaDNKNID.Text = kqDNKN.ID.ToString();
            txtNgayGiao.Text = kqDNKN.NGAYGIAO?.ToVNDate().Replace("-", "/");
            txtNgayNhan.Text = kqDNKN.NGAYNHAN?.ToVNDate().Replace("-", "/");
            txtNgayQD.Text = kqDNKN.NGAYQUYETDINH?.ToVNDate().Replace("-", "/");
            txtNgayThuLy.Text = kqDNKN.NGAYTHULY?.ToVNDate().Replace("-", "/");
			
            txtSoQD.Text = kqDNKN.SOQUYETDINH;
            txtSoThuLy.Text = kqDNKN.SOTHULY;
			if (this.checkQuyen() == false)
			{
				this.checkQuyen();
			}
			else
			{
                this.checkButon(kqDNKN);
            }
            pnDanhsach.Visible = false;
			pnCapnhat.Visible = true;
			pndata.Visible = false;
		}

		public void checkButon(HOAGIAI_DENGHI_KIENNGHI_KETQUA kq)
		{
            if (kq.NGAYGIAO != null)
            {
                Cls_Comon.SetButton(btnUpdateTL, false);
                Cls_Comon.SetButton(btnEditTL, true);
                Cls_Comon.SetButton(btnDeleteTL, true);
                pnlThuLy.Enabled = false;
                if (kq.SOQUYETDINH != null)
                {
                    lblThongBaoKQ.Text = "";
                    Cls_Comon.SetButton(btnUpdateKQ, false);
                    Cls_Comon.SetButton(btnEditKQ, true);
                    Cls_Comon.SetButton(btnDeleteKQ, true);
                    pnlGiaiQuyet.Enabled = false;
                }
                else
                {
                    lblThongBaoKQ.Text = "Chưa nhập kết quả";
                    Cls_Comon.SetButton(btnUpdateKQ, true);
                    Cls_Comon.SetButton(btnEditKQ, false);
                    Cls_Comon.SetButton(btnDeleteKQ, false);
                    pnlGiaiQuyet.Enabled = true;
                }
            }
            else
            {
                pnlGiaiQuyet.Enabled = false;
                pnlThuLy.Enabled = true;
                Cls_Comon.SetButton(btnUpdateTL, true);
                Cls_Comon.SetButton(btnEditTL, false);
                Cls_Comon.SetButton(btnDeleteTL, false);
                Cls_Comon.SetButton(btnUpdateKQ, false);
                Cls_Comon.SetButton(btnEditKQ, false);
                Cls_Comon.SetButton(btnDeleteKQ, false);
            }
        }
		protected void cmdQuaylai_Click(object sender, EventArgs e)
		{
			pnDanhsach.Visible = true;
			pnCapnhat.Visible = false;
			try
			{
				hddVuViecID.Value = "";
				hddPageIndex.Value = "1";
				hddTPTV1.Value = hddTPTV2.Value = hddTPCT.Value = "0";
				txtKetQuaDNKNID.Text = "";

                LoadGrid();
			}
			catch (Exception ex) { lbthongbao.Text = ex.Message; }
		}
		protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
		{
			//MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
			if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				DataRowView rowView = (DataRowView)e.Item.DataItem;
				LinkButton lblGiaiQuyet = (LinkButton)e.Item.FindControl("lblGiaiQuyet");
				if (rdbTrangthai.SelectedValue == "1")
				{
					lblGiaiQuyet.Text = "Chi tiết";

				}
				else
				{
					lblGiaiQuyet.Text = "Giải quyết";
				}
			}
		}
		protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
		{
			var dg = source as DataGrid;
			DataGridItem item = dg.Items[Convert.ToInt32(e.Item.ItemIndex)];
			switch (e.CommandName)
			{
				case "GiaiQuyet":
					this.OnGiaiQuyet(item);
                  
                    break;
			}

		}
		#region "Phân trang"
		protected void lbTBack_Click(object sender, EventArgs e)
		{
			try
			{
				hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
				LoadGrid();
			}
			catch (Exception ex) { lbthongbao.Text = ex.Message; }
		}
		protected void lbTFirst_Click(object sender, EventArgs e)
		{
			try
			{
				hddPageIndex.Value = "1";
				LoadGrid();
			}
			catch (Exception ex) { lbthongbao.Text = ex.Message; }
		}
		protected void lbTLast_Click(object sender, EventArgs e)
		{
			try
			{
				hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
				LoadGrid();
			}
			catch (Exception ex) { lbthongbao.Text = ex.Message; }
		}
		protected void lbTNext_Click(object sender, EventArgs e)
		{
			try
			{
				hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
				LoadGrid();
			}
			catch (Exception ex) { lbthongbao.Text = ex.Message; }
		}
		protected void lbTStep_Click(object sender, EventArgs e)
		{
			try
			{
				LinkButton lbCurrent = (LinkButton)sender;
				hddPageIndex.Value = lbCurrent.Text;
				LoadGrid();
			}
			catch (Exception ex) { lbthongbao.Text = ex.Message; }
		}
		#endregion
		protected void cmdTimkiem_Click(object sender, EventArgs e)
		{
			try
			{
				#region Validate
				if (txtTuNgay.Text != "" && Cls_Comon.IsValidDate(txtTuNgay.Text) == false)
				{
					lbthongbao.Text = "Bạn phải nhập kháng cáo từ ngày theo định dạng (dd/MM/yyyy)!";
					txtTuNgay.Focus();
					return;
				}
				if (txtDenNgay.Text != "" && Cls_Comon.IsValidDate(txtDenNgay.Text) == false)
				{
					lbthongbao.Text = "Bạn phải nhập kháng cáo đến ngày theo định dạng (dd/MM/yyyy)!";
					txtDenNgay.Focus();
					return;
				}
				if (txtTuNgay.Text != "" && txtDenNgay.Text != "")
				{
					DateTime TuNgay = DateTime.Parse(txtTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
					DateTime DenNgay = DateTime.Parse(txtDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
					if (DateTime.Compare(TuNgay, DenNgay) > 0)
					{
						lbthongbao.Text = "Bạn phải nhập ngày kháng cáo từ ngày phải nhỏ hơn đến ngày!";
						txtDenNgay.Focus();
						return;
					}
				}
				#endregion
				hddPageIndex.Value = "1";
				LoadGrid();
			}
			catch (Exception ex) { lbthongbao.Text = ex.Message; }
		}
		protected void chkChon_CheckedChanged(object sender, EventArgs e)
		{
			//if (rdbTrangthai.SelectedValue == "1")
			//{
			//    Cls_Comon.SetButton(cmdGiaiQuyet, false);
			//    return;
			//}
			CheckBox chkXem = (CheckBox)sender;
			decimal ID = Convert.ToDecimal(chkXem.ToolTip);
			foreach (DataGridItem Item in dgList.Items)
			{
				CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
				if (chkXem.Checked)
				{
					if (chkXem.ToolTip != chkChon.ToolTip) chkChon.Checked = false;
					Cls_Comon.SetButton(cmdGiaiQuyet, true);
				}
				else
					Cls_Comon.SetButton(cmdGiaiQuyet, false);
			}
		}
		#region Kết quả DNKN
		private void InitDataForm()
		{
			DM_TOAAN toa = new DM_TOAAN()
			{
				CAPCHAID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])
			};
			this.LoadThamPhan(toa);
			this.LoadToaAnTrucThuoc(toa);
			this.LoadKetQuaDNKN();
		}

		private void LoadKetQuaDNKN()
		{
			ddlKetQuaDNKN.Items.Insert(0, new ListItem("Đình chỉ việc xem xét đề nghị, kiến nghị", "3"));
			ddlKetQuaDNKN.Items.Insert(0, new ListItem("Không chấp nhận đề nghị/kiến nghị, giữ nguyên QĐ công nhận KQ " + hoagiaitext + " thành", "2"));
			ddlKetQuaDNKN.Items.Insert(0, new ListItem("Huỷ QĐ công nhận HG/ĐT thành và giao cho toà án có thẩm quyền xem xét lại", "1"));
		}

		private void LoadThamPhan(DM_TOAAN toa)
		{
			DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
			DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH((decimal)toa.CAPCHAID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
			ddlThamphan.DataSource = oCBDT;
			ddlThamphan.DataTextField = "MA_TEN";
			ddlThamphan.DataValueField = "ID";
			ddlThamphan.DataBind();
		}

		private void LoadToaAnTrucThuoc(DM_TOAAN toa)
		{
			DM_TOAAN_BL oBL = new DM_TOAAN_BL();
			if (toa != null && toa.CAPCHAID != null)
			{
				ddlToaAnTrucThuoc.DataSource = oBL.DM_TOAAN_GETBY((decimal)toa.CAPCHAID);
				ddlToaAnTrucThuoc.DataTextField = "arrTEN";
				ddlToaAnTrucThuoc.DataValueField = "ID";
				ddlToaAnTrucThuoc.DataBind();
			}

		}
		public void LoadGridKQ()
		{
			if (this.vuViecId == 0 || this.loaiAn == 0)
				return;
			HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
			var tbl = hoaGiaiBL.GetAllKetQuaDeNghiKienNghi(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, PageSize: 0, PageIndex: 10);
			dgKQ.CurrentPageIndex = 0;
			dgKQ.DataSource = tbl;
			dgKQ.DataBind();
            
        }
		protected void btnUpdate_Click(object sender, EventArgs e)
		{
			try
			{
				if (this.checkQuyen() == false)
					return;
				if (this.loaiAn == 0 || this.vuViecId == 0)
				{
					return;
				}
				string idQDStr = txtKetQuaDNKNID.Text;
				decimal idQD = 0;
				if (!String.IsNullOrEmpty(idQDStr))
				{
					idQD = Convert.ToDecimal(idQDStr);
				}
				HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDNKN = new HOAGIAI_DENGHI_KIENNGHI_KETQUA();
				if (idQD != 0)
				{
					kqDNKN = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(idQD);

					if (kqDNKN == null)
					{
						lblThongBao.Text = "Dữ liệu không đúng";
						throw new Exception("Dữ liệu không đúng");
					}
				}
				textKQ = idQD;
				string userName = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
				//   quyetDinh.NGAYHOAGIAI = (String.IsNullOrEmpty(txtNgayHoaGiai.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayHoaGiai.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); ;
				if (pnlGiaiQuyet.Enabled == false)
				{
					kqDNKN.NGAYGIAO = (String.IsNullOrEmpty(txtNgayGiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayGiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
					kqDNKN.NGAYNHAN = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
					kqDNKN.SOTHULY = txtSoThuLy.Text.Trim().ToString();
					kqDNKN.NGAYTHULY = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

				}
				else
				{
					kqDNKN.NGAYGIAO = (String.IsNullOrEmpty(txtNgayGiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayGiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
					kqDNKN.NGAYNHAN = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
					kqDNKN.SOTHULY = txtSoThuLy.Text.Trim().ToString();
					kqDNKN.NGAYTHULY = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

					kqDNKN.THAMPHANID = Convert.ToDecimal(ddlThamphan.SelectedValue);
					kqDNKN.TOANHANID = Convert.ToDecimal(ddlToaAnTrucThuoc.SelectedValue);
					kqDNKN.QUYETDINHID = Convert.ToDecimal(ddlKetQuaDNKN.SelectedValue);
					kqDNKN.NGAYQUYETDINH = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
					kqDNKN.SOQUYETDINH = txtSoQD.Text.Trim().ToString();
				}





				bool isVaild = this.CheckValid(kqDNKN);
				if (!isVaild)
					return;
				HOAGIAI_DON hg = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID={this.vuViecId} AND LOAIANID={this.loaiAn}").FirstOrDefault();
				kqDNKN.HOAGIAIID = hg.ID;
				if (idQD == 0)
				{
					kqDNKN.NGAYTAO = DateTime.Now;
					kqDNKN.NGUOITAO = userName;
				}
				else
				{
					kqDNKN.NGAYSUA = DateTime.Now;
					kqDNKN.NGUOISUA = userName;
				}
				bool isAction = false;
				if (idQD == 0)
				{
					decimal isInsert = DataExtensions.Insert<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(kqDNKN);
					if (isInsert != 0)
					{
						isAction = true;
					}
				}
				else
				{
					isAction = DataExtensions.Update<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(kqDNKN);
				}
				if (isAction)
				{
					HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDnKnUpdateDon = DataExtensions.GetAllWithClause<HOAGIAI_DENGHI_KIENNGHI_KETQUA>($"HOAGIAIID = {kqDNKN.HOAGIAIID} ORDER BY NGAYQUYETDINH DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

					#region nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

					int ketQuaID = 0;
					if (kqDnKnUpdateDon.QUYETDINHID == 1)
						ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH;
					if (kqDnKnUpdateDon.QUYETDINHID == 2)
						ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH;
					if (ketQuaID != 0 && ketQuaID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
					{
						this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ketQuaID);
						//Không cần load lại để tải lại menu nữa
						//Page.Response.Redirect(Page.Request.Url.ToString(), false);
						//Context.ApplicationInstance.CompleteRequest();
					}
					else if (ketQuaID == 0)
					{
						//Cập nhật lại theo QD
						HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {kqDNKN.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
						if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
						{
							this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)qdUPdateDon.KETQUAID);
							//Không cần load lại để tải lại menu nữa
							//Page.Response.Redirect(Page.Request.Url.ToString(), false);
							//Context.ApplicationInstance.CompleteRequest();
						}
					}

					#endregion nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật
					this.LoadGridKQ();
					//pnlGiaiQuyet.Enabled = true;
					lblThongBao.Text = "Lưu thành công";
					//pnlThuLy.Enabled = false;
					//Cls_Comon.SetButton(btnUpdateTL, false);
					checkButon(kqDNKN);
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
				throw new Exception("Dữ liệu không đúng");
			}
		}
		protected void btnLammoi_Click(object sender, EventArgs e)
		{
			txtNgayGiao.Text =
				txtNgayNhan.Text =
				txtSoQD.Text =
				txtNgayThuLy.Text =
				txtNgayQD.Text = "";
			ddlKetQuaDNKN.SelectedIndex = 0;
			ddlThamphan.SelectedIndex = 0;
			ddlToaAnTrucThuoc.SelectedIndex = 0;
			txtSoThuLy.Text = "";
			//pnlGiaiQuyet.Enabled= false;
		}
		private bool CheckValid(HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDNKN)
		{
			if (pnlGiaiQuyet.Enabled == false)
			{

				if (kqDNKN.NGAYGIAO == null)
				{
					lblThongBao.Text = "Ngày giao không được để trống";
					return false;
				}
				if (kqDNKN.NGAYNHAN == null)
				{
					lblThongBao.Text = "Ngày nhận không được để trống";
					return false;
				}
				if (kqDNKN.SOTHULY == null)
				{
					lblThongBao.Text = "Số thụ lý không được để trống";
					return false;
				}
				if (kqDNKN.NGAYTHULY == null)
				{
					lblThongBao.Text = "Ngày thụ lý không được để trống";
					return false;
				}

			}
			else
			{
				if (kqDNKN.THAMPHANID == null)
				{
					lblThongBaoKQ.Text = "Thẩm phán không được để trống";
					return false;
				}
				if (kqDNKN.TOANHANID == null)
				{
					lblThongBaoKQ.Text = "Tòa án không được để trống";
					return false;
				}
				if (kqDNKN.QUYETDINHID == null)
				{
					lblThongBaoKQ.Text = "Kết quả không được để trống";
					return false;
				}
				if (kqDNKN.NGAYQUYETDINH == null)
				{
					lblThongBaoKQ.Text = "Ngày quyết định không được để trống";
					return false;
				}
				if (kqDNKN.SOQUYETDINH == null)
				{
					lblThongBaoKQ.Text = "Số quyết định không được để trống";
					return false;
				}
			}



			return true;
		}
		public bool checkQuyen()
		{
			var checkPCTPQGD = _hoaGiaiBl.CheckPCTPQGD(this.vuViecId, this.loaiAn);
			if (checkPCTPQGD)
			{
                Cls_Comon.SetButton(btnUpdateTL, true);
                Cls_Comon.SetButton(btnUpdateKQ, true);
                Cls_Comon.SetButton(btnEditTL, true);
                Cls_Comon.SetButton(btnEditKQ, true);
                Cls_Comon.SetButton(btnDeleteTL, true);
                Cls_Comon.SetButton(btnDeleteKQ, true);
            }
			else
			{
				Cls_Comon.SetButton(btnUpdateTL, false);
				Cls_Comon.SetButton(btnUpdateKQ, false);
				Cls_Comon.SetButton(btnEditTL, false);
				Cls_Comon.SetButton(btnEditKQ, false);
				Cls_Comon.SetButton(btnDeleteTL, false);
				Cls_Comon.SetButton(btnDeleteKQ, false);
				

				hddShowCommand.Value = "False";
				lblThongBao.Text= lblThongBaoKQ.Text = "Vụ việc đã được phân công thẩm phán giải quyết đơn. Không được sửa!";
				
				return false;
			}
			var checkThuLy = _hoaGiaiBl.CheckThuLy(this.vuViecId, this.loaiAn);
			if (checkThuLy)
			{
                Cls_Comon.SetButton(btnUpdateTL, true);
                Cls_Comon.SetButton(btnUpdateKQ, true);
                Cls_Comon.SetButton(btnEditTL, true);
                Cls_Comon.SetButton(btnEditKQ, true);
                Cls_Comon.SetButton(btnDeleteTL, true);
                Cls_Comon.SetButton(btnDeleteKQ, true);

            }
			else
			{
                Cls_Comon.SetButton(btnUpdateTL, false);
                Cls_Comon.SetButton(btnUpdateKQ, false);
                Cls_Comon.SetButton(btnEditTL, false);
                Cls_Comon.SetButton(btnEditKQ, false);
                Cls_Comon.SetButton(btnDeleteTL, false);
                Cls_Comon.SetButton(btnDeleteKQ, false);
                hddShowCommand.Value = "False";
				lblThongBao.Text =lblThongBaoKQ.Text= "Vụ việc đã được thụ lý. Không được sửa!";
				return false;
			}
			var hoaGiaiDon = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID = {this.vuViecId} AND LOAIANID = {this.loaiAn}").FirstOrDefault();
			var deNghiKienNghi = DataExtensions.GetAllWithClause<HOAGIAI_DENGHI_KIENNGHI>($"HOAGIAIID = {hoaGiaiDon.ID}").FirstOrDefault();
			var ketQuaDNKN = DataExtensions.GetAllWithClause<HOAGIAI_DENGHI_KIENNGHI_KETQUA>($"SOTHULY is not null and HOAGIAIID = {hoaGiaiDon.ID}").FirstOrDefault();
			if (deNghiKienNghi == null)
			{
				Cls_Comon.SetButton(btnUpdateTL, false); //fix

				//Cls_Comon.SetButton(btnLammoi, false); fix
				hddShowCommand.Value = "False";
				lblThongBao.Text=lblThongBaoKQ.Text = "Vụ việc chưa có đề nghị kiến nghị.";
				return false;
			}
	
			return true;
		}
		protected void dgList_ItemCommandKQ(object source, DataGridCommandEventArgs e)
		{
			try
			{
				decimal APID = Convert.ToDecimal(e.CommandArgument.ToString());
				switch (e.CommandName)
				{
					case "Sua":

						LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
						if (lblSua.Text == "Chi tiết")
						{
							Cls_Comon.SetButton(btnUpdateKQ, true);//fix
							Cls_Comon.SetButton(btnUpdateTL, true);
						}
						else
						{
							Cls_Comon.SetButton(btnUpdateKQ, false);//fix
						}
						pnlGiaiQuyet.Enabled = true;
						HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDNKN = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(APID);
						if (kqDNKN == null)
						{
							lblThongBao.Text = "Không tồn tại kết quả giải quyết đề nghị kiến nghị";
							return;
						}
						txtKetQuaDNKNID.Text = kqDNKN.ID.ToString();
						txtNgayGiao.Text = kqDNKN.NGAYGIAO?.ToVNDate().Replace("-", "/");
						txtNgayNhan.Text = kqDNKN.NGAYNHAN?.ToVNDate().Replace("-", "/");
						txtNgayQD.Text = kqDNKN.NGAYQUYETDINH?.ToVNDate().Replace("-", "/");
						txtNgayThuLy.Text = kqDNKN.NGAYTHULY?.ToVNDate().Replace("-", "/");
						txtSoQD.Text = kqDNKN.SOQUYETDINH;
						txtSoThuLy.Text = kqDNKN.SOTHULY;
						try
						{
							if (kqDNKN.QUYETDINHID != null)
							{
								ddlKetQuaDNKN.SelectedValue = kqDNKN.QUYETDINHID.ToString();
							}
							if (kqDNKN.THAMPHANID != null)
							{
								ddlThamphan.SelectedValue = kqDNKN.THAMPHANID.ToString();
							}
							if (kqDNKN.TOANHANID != null)
							{
								ddlToaAnTrucThuoc.SelectedValue = kqDNKN.TOANHANID.ToString();
							}
						}
						catch
						{
							lblThongBao.Text = "Không thể sửa do có dữ liệu không hợp lệ";
						}
						break;

					case "Xoa":
						try
						{
							MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
							if (oPer.XOA == false || btnUpdateTL.Enabled == false) //fix
							{
								lblThongBao.Text = "Bạn không có quyền xóa!";
								return;
							}
							HOAGIAI_DENGHI_KIENNGHI_KETQUA ketQuadeNghiKienNghi = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(APID);
							if (ketQuadeNghiKienNghi == null)
							{
								lblThongBao.Text = "Không tồn tại kết quả giải quyết đề nghị kiến nghị";
								return;
							}
							bool result = DataExtensions.Delete<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(new HOAGIAI_DENGHI_KIENNGHI_KETQUA() { ID = APID });
							//if (deNghiKienNghi.FILEID != null)
							//{
							//    HOAGIAI_FILE hOAGIAI_FILE = DataExtensions.FindById<HOAGIAI_FILE>((decimal)deNghiKienNghi.FILEID);
							//    QT_FILE qT_FILE = DataExtensions.FindById<QT_FILE>((decimal)hOAGIAI_FILE.FILESERVER_ID);
							//    QT_FILE_BL file_BL = new QT_FILE_BL();
							//    file_BL.DeleteFileLogic(qT_FILE);
							//}
							if (result)
							{
								HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDnKnUpdateDon = DataExtensions.GetAllWithClause<HOAGIAI_DENGHI_KIENNGHI_KETQUA>($"HOAGIAIID = {ketQuadeNghiKienNghi.HOAGIAIID} ORDER BY NGAYQUYETDINH DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

								if (kqDnKnUpdateDon != null)
								{
									#region nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

									int ketQuaID = 0;
									if (kqDnKnUpdateDon.QUYETDINHID == 1)
										ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH;
									if (kqDnKnUpdateDon.QUYETDINHID == 2)
										ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH;
									if (ketQuaID != 0 && ketQuaID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
									{
										this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ketQuaID);
										//Page.Response.Redirect(Page.Request.Url.ToString(), false);
										//Context.ApplicationInstance.CompleteRequest();
										//lblThongBao.Text = "Xóa thành công!";
										//return;
									}
									else if (ketQuaID == 0)
									{
										//Cập nhật lại theo QD
										HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {ketQuadeNghiKienNghi.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
										if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
										{
											this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)qdUPdateDon.KETQUAID);
											//Page.Response.Redirect(Page.Request.Url.ToString(), false);
											//Context.ApplicationInstance.CompleteRequest();
											//lblThongBao.Text = "Xóa thành công!";
											//return;
										}
									}
								}
								else
								{
									HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {ketQuadeNghiKienNghi.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
									if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
									{
										this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)qdUPdateDon.KETQUAID);
										//Page.Response.Redirect(Page.Request.Url.ToString(), false);
										//Context.ApplicationInstance.CompleteRequest();
										//lblThongBao.Text = "Xóa thành công!";
										//return;
									}
								}

								#endregion nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

								lblThongBao.Text = "Xóa thành công!";
								this.btnLammoi_Click(null, null);
								this.LoadGridKQ();
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

		protected void dgList_ItemDataBoundKQ(object source, DataGridItemEventArgs e)
		{
			MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
			if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
			{
				DataRowView row = (DataRowView)e.Item.DataItem;
				//var isExistsFile = String.IsNullOrEmpty(row["FILESID"].ToString());
				//if (isExistsFile)
				//{
				//    var button = (ImageButton)e.Item.FindControl("lblDownload");
				//    //var lable = (System.Web.UI.WebControls.Label)e.Item.FindControl("lblKhongCoFile");
				//    button.Visible = !isExistsFile;
				//    //lable.Visible = isExistsFile;
				//}

				LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
				Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

				LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
				lbtXoa.Visible = false;
				Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
				if (this.isUpdateAction)
				{
					lblSua.Text = "Chi tiết";
					lbtXoa.Visible = false;
				}
				else
				{
					lbtXoa.Visible = false;
					lblSua.Text = "Chi tiết";
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
				if (!Convert.ToBoolean(hddShowCommand.Value))
				{
					lbtXoa.Visible = false;
					lblSua.Text = "Chi tiết";
				}
			}
		}

		#endregion

		protected void btnUpdateKQ_Click(object sender, EventArgs e)
		{
			try
			{
				if (this.checkQuyen() == false)
					return;
				if (this.loaiAn == 0 || this.vuViecId == 0)
				{
					return;
				}
				HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
				var tbl = hoaGiaiBL.GetAllKetQuaDeNghiKienNghi(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, PageSize: 0, PageIndex: 10);
				foreach (DataRow row in tbl.Rows)
				{
					txtKetQuaDNKNID.Text = row["ID"].ToString();
				}
				string idQDStr = txtKetQuaDNKNID.Text;
				decimal idQD = 0;
				if (!String.IsNullOrEmpty(idQDStr))
				{
					idQD = Convert.ToDecimal(idQDStr);
				}
				HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDNKN = new HOAGIAI_DENGHI_KIENNGHI_KETQUA();
				if (idQD != 0)
				{
					kqDNKN = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(idQD);

					if (kqDNKN == null)
					{
						lblThongBaoKQ.Text = "Dữ liệu không đúng";
						throw new Exception("Dữ liệu không đúng");
					}
				}
				
				string userName = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
				//   quyetDinh.NGAYHOAGIAI = (String.IsNullOrEmpty(txtNgayHoaGiai.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayHoaGiai.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); ;
				if (pnlGiaiQuyet.Enabled == false)
				{
					kqDNKN.NGAYGIAO = (String.IsNullOrEmpty(txtNgayGiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayGiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
					kqDNKN.NGAYNHAN = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
					kqDNKN.SOTHULY = txtSoThuLy.Text.Trim().ToString();
					kqDNKN.NGAYTHULY = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

				}
				else
				{
					kqDNKN.NGAYGIAO = (String.IsNullOrEmpty(txtNgayGiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayGiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
					kqDNKN.NGAYNHAN = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
					kqDNKN.SOTHULY = txtSoThuLy.Text.Trim().ToString();
					kqDNKN.NGAYTHULY = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

					kqDNKN.THAMPHANID = Convert.ToDecimal(ddlThamphan.SelectedValue);
					kqDNKN.TOANHANID = Convert.ToDecimal(ddlToaAnTrucThuoc.SelectedValue);
					kqDNKN.QUYETDINHID = Convert.ToDecimal(ddlKetQuaDNKN.SelectedValue);
					kqDNKN.NGAYQUYETDINH = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
					kqDNKN.SOQUYETDINH = txtSoQD.Text.Trim().ToString();
				}

				bool isVaild = this.CheckValid(kqDNKN);
				if (!isVaild)
					return;
				HOAGIAI_DON hg = DataExtensions.GetAllWithClause<HOAGIAI_DON>($"VUVIECID={this.vuViecId} AND LOAIANID={this.loaiAn}").FirstOrDefault();
				kqDNKN.HOAGIAIID = hg.ID;
				if (idQD == 0)
				{
					kqDNKN.NGAYTAO = DateTime.Now;
					kqDNKN.NGUOITAO = userName;
				}
				else
				{
					kqDNKN.NGAYSUA = DateTime.Now;
					kqDNKN.NGUOISUA = userName;
				}
				bool isAction = false;
				if (idQD == 0)
				{
					decimal isInsert = DataExtensions.Insert<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(kqDNKN);
					if (isInsert != 0)
					{
						isAction = true;
					}
				}
				else
				{
					isAction = DataExtensions.Update<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(kqDNKN);
				}
				if (isAction)
				{
					HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDnKnUpdateDon = DataExtensions.GetAllWithClause<HOAGIAI_DENGHI_KIENNGHI_KETQUA>($"HOAGIAIID = {kqDNKN.HOAGIAIID} ORDER BY NGAYQUYETDINH DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

					#region nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

					int ketQuaID = 0;
					if (kqDnKnUpdateDon.QUYETDINHID == 1)
						ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH;
					if (kqDnKnUpdateDon.QUYETDINHID == 2)
						ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH;
					if (ketQuaID != 0 && ketQuaID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
					{
						this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ketQuaID);
						//Không cần load lại để tải lại menu nữa
						//Page.Response.Redirect(Page.Request.Url.ToString(), false);
						//Context.ApplicationInstance.CompleteRequest();
					}
					else if (ketQuaID == 0)
					{
						//Cập nhật lại theo QD
						HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {kqDNKN.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
						if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
						{
							this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)qdUPdateDon.KETQUAID);
							//Không cần load lại để tải lại menu nữa
							//Page.Response.Redirect(Page.Request.Url.ToString(), false);
							//Context.ApplicationInstance.CompleteRequest();
						}
					}

					#endregion nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật
					this.LoadGridKQ();
					checkButon(kqDNKN);
					lblThongBaoKQ.Text = "Lưu thành công";
				}
				else
				{
					lblThongBaoKQ.Text = "Thao tác thất bại";
				}
			}
			catch
			{
				lblThongBaoKQ.Text = "Dữ liệu không đúng";
				throw new Exception("Dữ liệu không đúng");
			}
		}

		protected void btnEditTL_Click(object sender, EventArgs e)
		{
			try
			{
				lblThongBao.Text = "";
				pnlThuLy.Enabled = true;
				pnlGiaiQuyet.Enabled = false;
				Cls_Comon.SetButton(btnUpdateTL, true);
				Cls_Comon.SetButton(btnEditTL, true);
				Cls_Comon.SetButton(btnDeleteTL,true);
				Cls_Comon.SetButton(btnUpdateKQ, false);
				Cls_Comon.SetButton(btnEditKQ, false);
				Cls_Comon.SetButton(btnDeleteKQ, false);
                HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
				var tbl = hoaGiaiBL.GetAllKetQuaDeNghiKienNghi(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, PageSize: 0, PageIndex: 10);
				foreach (DataRow row in tbl.Rows)
				{
					txtKetQuaDNKNID.Text = row["ID"].ToString();
				}
				string idQDStr = txtKetQuaDNKNID.Text;
				if (idQDStr == "")
				{
					lblThongBao.Text = "Chưa có thụ lý đề nghị kiến nghị";
					return;
				}
				decimal idQD = 0;
				if (!String.IsNullOrEmpty(idQDStr))
				{
					idQD = Convert.ToDecimal(idQDStr);
				}
				HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDNKN = new HOAGIAI_DENGHI_KIENNGHI_KETQUA();
				if (idQD != 0)
				{
					kqDNKN = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(idQD);

					if (kqDNKN == null)
					{
						lblThongBao.Text = "Dữ liệu không đúng";
						return;
					}
				}
				txtKetQuaDNKNID.Text = kqDNKN.ID.ToString();
				txtNgayGiao.Text = kqDNKN.NGAYGIAO?.ToVNDate().Replace("-", "/");
				txtNgayNhan.Text = kqDNKN.NGAYNHAN?.ToVNDate().Replace("-", "/");
				txtNgayQD.Text = kqDNKN.NGAYQUYETDINH?.ToVNDate().Replace("-", "/");
				txtNgayThuLy.Text = kqDNKN.NGAYTHULY?.ToVNDate().Replace("-", "/");
				txtSoQD.Text = kqDNKN.SOQUYETDINH;
				txtSoThuLy.Text = kqDNKN.SOTHULY;
			}
			catch (Exception ex)
			{

				lblThongBao.Text = ex.Message;
			}

		}

		protected void btnEditKQ_Click(object sender, EventArgs e)
		{
			try
			{
				lblThongBaoKQ.Text = "";
				pnlThuLy.Enabled=false;
				pnlGiaiQuyet.Enabled = true;
                pnlThuLy.Enabled = false;
                pnlGiaiQuyet.Enabled = true;
                Cls_Comon.SetButton(btnUpdateTL, false);
                Cls_Comon.SetButton(btnEditTL, false);
                Cls_Comon.SetButton(btnDeleteTL, false);
                Cls_Comon.SetButton(btnUpdateKQ, true);
                Cls_Comon.SetButton(btnEditKQ, true);
                Cls_Comon.SetButton(btnDeleteKQ, true);
                HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
				var tbl = hoaGiaiBL.GetAllKetQuaDeNghiKienNghi(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, PageSize: 0, PageIndex: 10);
				foreach (DataRow row in tbl.Rows)
				{
					txtKetQuaDNKNID.Text = row["ID"].ToString();
				}

				string idQDStr = txtKetQuaDNKNID.Text;
				if (idQDStr == "")
				{
					lblThongBaoKQ.Text = "Chưa có thụ lý đề nghị kiến nghị";
					return;
				}
				decimal idQD = 0;
				if (!String.IsNullOrEmpty(idQDStr))
				{
					idQD = Convert.ToDecimal(idQDStr);
				}
				HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDNKN = new HOAGIAI_DENGHI_KIENNGHI_KETQUA();
				if (idQD != 0)
				{
					kqDNKN = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(idQD);
					pnlThuLy.Enabled = false;
					pnlGiaiQuyet.Enabled = true;
					Cls_Comon.SetButton(btnUpdateKQ, true);
					if (kqDNKN == null)
					{
						lblThongBaoKQ.Text = "Dữ liệu không đúng";
						throw new Exception("Dữ liệu không đúng");
					}
				}
				if (kqDNKN.QUYETDINHID == null)
				{
					lblThongBaoKQ.Text = "Chưa có giải quyết đề nghị/kiến nghị";

					return;
				}
				txtKetQuaDNKNID.Text = kqDNKN.ID.ToString();
				txtNgayGiao.Text = kqDNKN.NGAYGIAO?.ToVNDate().Replace("-", "/");
				txtNgayNhan.Text = kqDNKN.NGAYNHAN?.ToVNDate().Replace("-", "/");
				txtNgayQD.Text = kqDNKN.NGAYQUYETDINH?.ToVNDate().Replace("-", "/");
				txtNgayThuLy.Text = kqDNKN.NGAYTHULY?.ToVNDate().Replace("-", "/");
				txtSoQD.Text = kqDNKN.SOQUYETDINH;
				txtSoThuLy.Text = kqDNKN.SOTHULY;
			}
			catch (Exception ex)
			{

				lblThongBaoKQ.Text = ex.Message;
			}
		}

		protected void btnDeleteTL_Click(object sender, EventArgs e)
		{
			try
			{
				lblThongBao.Text = "";
				HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
				var tbl = hoaGiaiBL.GetAllKetQuaDeNghiKienNghi(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, PageSize: 0, PageIndex: 10);
				foreach (DataRow row in tbl.Rows)
				{
					txtKetQuaDNKNID.Text = row["ID"].ToString();
				}
				string idQDStr = txtKetQuaDNKNID.Text;

				decimal idQD = 0;
				if (!String.IsNullOrEmpty(idQDStr))
				{
					idQD = Convert.ToDecimal(idQDStr);
				}
				HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDNKN = new HOAGIAI_DENGHI_KIENNGHI_KETQUA();
				if (idQD != 0)
				{
					kqDNKN = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(idQD);

					if (kqDNKN == null)
					{
						lblThongBao.Text = "Dữ liệu không đúng";
						throw new Exception("Dữ liệu không đúng");
					}
				}

				if (kqDNKN != null)
				{
					if (kqDNKN.QUYETDINHID != null)
					{
						lblThongBao.Text = "Bạn chưa xóa giải quyết đề nghị/kiến nghị";
						return;
					}
					else
					{
						try
						{
							HOAGIAI_DENGHI_KIENNGHI_KETQUA ketQuadeNghiKienNghi = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(idQD);
							if (ketQuadeNghiKienNghi == null)
							{
								lblThongBao.Text = "Không tồn tại kết quả giải quyết đề nghị kiến nghị";
								return;
							}
							bool result = DataExtensions.Delete<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(new HOAGIAI_DENGHI_KIENNGHI_KETQUA() { ID = idQD });
							//if (deNghiKienNghi.FILEID != null)
							//{
							//    HOAGIAI_FILE hOAGIAI_FILE = DataExtensions.FindById<HOAGIAI_FILE>((decimal)deNghiKienNghi.FILEID);
							//    QT_FILE qT_FILE = DataExtensions.FindById<QT_FILE>((decimal)hOAGIAI_FILE.FILESERVER_ID);
							//    QT_FILE_BL file_BL = new QT_FILE_BL();
							//    file_BL.DeleteFileLogic(qT_FILE);
							//}
							if (result)
							{
								HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDnKnUpdateDon = DataExtensions.GetAllWithClause<HOAGIAI_DENGHI_KIENNGHI_KETQUA>($"HOAGIAIID = {ketQuadeNghiKienNghi.HOAGIAIID} ORDER BY NGAYQUYETDINH DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

								if (kqDnKnUpdateDon != null)
								{
									#region nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

									int ketQuaID = 0;
									if (kqDnKnUpdateDon.QUYETDINHID == 1)
										ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH;
									if (kqDnKnUpdateDon.QUYETDINHID == 2)
										ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH;
									if (ketQuaID != 0 && ketQuaID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
									{
										this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ketQuaID);
										//Page.Response.Redirect(Page.Request.Url.ToString(), false);
										//Context.ApplicationInstance.CompleteRequest();
										//lblThongBao.Text = "Xóa thành công!";
										//return;
									}
									else if (ketQuaID == 0)
									{
										//Cập nhật lại theo QD
										HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {ketQuadeNghiKienNghi.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
										if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
										{
											this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)qdUPdateDon.KETQUAID);
											//Page.Response.Redirect(Page.Request.Url.ToString(), false);
											//Context.ApplicationInstance.CompleteRequest();
											//lblThongBao.Text = "Xóa thành công!";
											//return;
										}
									}
								}
								else
								{
									HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {ketQuadeNghiKienNghi.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
									if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
									{
										this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)qdUPdateDon.KETQUAID);
										//Page.Response.Redirect(Page.Request.Url.ToString(), false);
										//Context.ApplicationInstance.CompleteRequest();
										//lblThongBao.Text = "Xóa thành công!";
										//return;
									}
								}

                                #endregion nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật
                                
                                lblThongBao.Text = "Xóa thành công!";
								this.btnLammoi_Click(null, null);
								this.LoadGridKQ();
								pnlThuLy.Enabled = true;
								pnlGiaiQuyet.Enabled = false;
								Cls_Comon.SetButton(btnUpdateTL, true);
								Cls_Comon.SetButton(btnEditTL, false);
								Cls_Comon.SetButton(btnDeleteTL,false);
								Cls_Comon.SetButton(btnUpdateKQ,false);
								Cls_Comon.SetButton(btnEditKQ,false);
								Cls_Comon.SetButton(btnDeleteKQ,false);
								txtKetQuaDNKNID.Text = string.Empty;
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
					}
				}
			}
			catch (Exception ex)
			{

				lblThongBao.Text = ex.Message;
			}
		}

		public void loadKetQua()
		{
            HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
            var tbl = hoaGiaiBL.GetAllKetQuaDeNghiKienNghi(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, PageSize: 0, PageIndex: 10);
            foreach (DataRow row in tbl.Rows)
            {
                txtKetQuaDNKNID.Text = row["ID"].ToString();
            }

            string idQDStr = txtKetQuaDNKNID.Text;
            decimal idQD = 0;
            if (!String.IsNullOrEmpty(idQDStr))
            {
                idQD = Convert.ToDecimal(idQDStr);
            }
            HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDNKN = new HOAGIAI_DENGHI_KIENNGHI_KETQUA();
            if (idQD != 0)
            {
                kqDNKN = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(idQD);
                pnlThuLy.Enabled = false;
                pnlGiaiQuyet.Enabled = true;
                Cls_Comon.SetButton(btnUpdateKQ, true);
                if (kqDNKN == null)
                {
                    lblThongBao.Text = "Dữ liệu không đúng";
                    throw new Exception("Dữ liệu không đúng");
                }
            }
            txtKetQuaDNKNID.Text = kqDNKN.ID.ToString();
            txtNgayGiao.Text = kqDNKN.NGAYGIAO?.ToVNDate().Replace("-", "/");
            txtNgayNhan.Text = kqDNKN.NGAYNHAN?.ToVNDate().Replace("-", "/");
            txtNgayQD.Text = kqDNKN.NGAYQUYETDINH?.ToVNDate().Replace("-", "/");
            txtNgayThuLy.Text = kqDNKN.NGAYTHULY?.ToVNDate().Replace("-", "/");
            txtSoQD.Text = kqDNKN.SOQUYETDINH;
            txtSoThuLy.Text = kqDNKN.SOTHULY;
        }

		protected void btnDeleteKQ_Click(object sender, EventArgs e)
		{
			try
			{
				lblThongBaoKQ.Text = "";
				HOAGIAI_BL hoaGiaiBL = new HOAGIAI_BL();
				var tbl = hoaGiaiBL.GetAllKetQuaDeNghiKienNghi(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, PageSize: 0, PageIndex: 10);
				foreach (DataRow row in tbl.Rows)
				{
					txtKetQuaDNKNID.Text = row["ID"].ToString();
				}
				string idQDStr = txtKetQuaDNKNID.Text;
				decimal idQD = 0;
				if (!String.IsNullOrEmpty(idQDStr))
				{
					idQD = Convert.ToDecimal(idQDStr);
				}
				HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDNKN = new HOAGIAI_DENGHI_KIENNGHI_KETQUA();
				if (idQD != 0)
				{
					kqDNKN = DataExtensions.FindById<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(idQD);

					if (kqDNKN == null)
					{
						lblThongBaoKQ.Text = "Dữ liệu không đúng";
						throw new Exception("Dữ liệu không đúng");
					}
				}

				if (kqDNKN != null)
				{
					if (kqDNKN.QUYETDINHID == null)
					{
						lblThongBaoKQ.Text = "Chưa có giải quyết đề nghị/kiến nghị";
						return;
					}
					else
					{
						try
						{
							if (kqDNKN == null)
							{
								lblThongBaoKQ.Text = "Không tồn tại kết quả giải quyết đề nghị kiến nghị";
								return;
							}
							if (kqDNKN != null)
							{
								kqDNKN.QUYETDINHID = null;
								kqDNKN.TOANHANID = null;
								kqDNKN.THAMPHANID = null;
								kqDNKN.SOQUYETDINH = null;
								kqDNKN.NGAYQUYETDINH = null;
							}
							bool result = DataExtensions.Update<HOAGIAI_DENGHI_KIENNGHI_KETQUA>(kqDNKN);
							//if (deNghiKienNghi.FILEID != null)
							//{
							//    HOAGIAI_FILE hOAGIAI_FILE = DataExtensions.FindById<HOAGIAI_FILE>((decimal)deNghiKienNghi.FILEID);
							//    QT_FILE qT_FILE = DataExtensions.FindById<QT_FILE>((decimal)hOAGIAI_FILE.FILESERVER_ID);
							//    QT_FILE_BL file_BL = new QT_FILE_BL();
							//    file_BL.DeleteFileLogic(qT_FILE);
							//}
							if (result)
							{
								HOAGIAI_DENGHI_KIENNGHI_KETQUA kqDnKnUpdateDon = DataExtensions.GetAllWithClause<HOAGIAI_DENGHI_KIENNGHI_KETQUA>($"HOAGIAIID = {kqDNKN.HOAGIAIID} ORDER BY NGAYQUYETDINH DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();

								if (kqDnKnUpdateDon != null)
								{
									#region nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

									int ketQuaID = 0;
									if (kqDnKnUpdateDon.QUYETDINHID == 1)
										ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_KHONGTHANH;
									if (kqDnKnUpdateDon.QUYETDINHID == 2)
										ketQuaID = (int)ENUM_TRANGTHAI_HOAGIAI.HOAGIAI_THANH;
									if (ketQuaID != 0 && ketQuaID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
									{
										this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)ketQuaID);
										//Page.Response.Redirect(Page.Request.Url.ToString(), false);
										//Context.ApplicationInstance.CompleteRequest();
										//lblThongBao.Text = "Xóa thành công!";
										//return;
									}
									else if (ketQuaID == 0)
									{
										//Cập nhật lại theo QD
										HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {kqDNKN.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
										if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
										{
											this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)qdUPdateDon.KETQUAID);
											//Page.Response.Redirect(Page.Request.Url.ToString(), false);
											//Context.ApplicationInstance.CompleteRequest();
											//lblThongBao.Text = "Xóa thành công!";
											//return;
										}
									}
								}
								else
								{
									HOAGIAI_QUYETDINH qdUPdateDon = DataExtensions.GetAllWithClause<HOAGIAI_QUYETDINH>($"HOAGIAIID = {kqDNKN.HOAGIAIID} ORDER BY NGAYHOAGIAI DESC FETCH NEXT 1 ROWS ONLY").FirstOrDefault();
									if (qdUPdateDon.KETQUAID != this._hoaGiaiBl.GetTrangThaiHoaGiaiHienTai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn))
									{
										this._hoaGiaiBl.UpdateTrangThaiHoaGiai(V_MAVUVIEC: this.vuViecId, V_LOAIANID: this.loaiAn, trangThai: (decimal)qdUPdateDon.KETQUAID);
										//Page.Response.Redirect(Page.Request.Url.ToString(), false);
										//Context.ApplicationInstance.CompleteRequest();
										//lblThongBao.Text = "Xóa thành công!";
										//return;
									}
								}

								#endregion nếu trạng thái mới nhất khác trạng thái hiện tại của đơn thì mới cập nhật

								lblThongBaoKQ.Text = "Xóa thành công!";
								//this.btnLammoi_Click(null, null);
								this.LoadGridKQ();
								this.loadKetQua();
                                pnlThuLy.Enabled = false;
                                pnlGiaiQuyet.Enabled = true;
                                Cls_Comon.SetButton(btnUpdateTL, false);
                                Cls_Comon.SetButton(btnEditTL, true);
                                Cls_Comon.SetButton(btnDeleteTL, true);
                                Cls_Comon.SetButton(btnUpdateKQ, true);
                                Cls_Comon.SetButton(btnEditKQ, false);
                                Cls_Comon.SetButton(btnDeleteKQ, false);
                                txtKetQuaDNKNID.Text = string.Empty;
							}
							else
							{
								lblThongBaoKQ.Text = "Không thể xóa hãy thử lại";
							}
						}
						catch (Exception ex)
						{
							lblThongBaoKQ.Text = ex.Message;
						}
					}
				}
			}
			catch (Exception ex)
			{
				lblThongBaoKQ.Text = ex.Message;
			}
		}
	}
}