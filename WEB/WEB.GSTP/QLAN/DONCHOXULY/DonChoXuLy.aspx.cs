using System;
using DAL.GSTP;
using Module.Common;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using BL.GSTP.DONCHOXULY;
using System.Web.UI;
using System.Text;
using System.Net;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Configuration;

namespace WEB.GSTP.QLAN.DONCHOXULY
{
    public partial class DonChoXuLy : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Load_Data();
            }
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            clear_form_search();
        }
        protected void clear_form_search()
        {
            ddlNguonDen.SelectedIndex = -1;
            txtNguoiGuiDon.Text = "";
            ddlLoaiAn.SelectedIndex = -1;
            txtSoLuongDon.Text = "";
            txtSoDenTu.Text = "";
            ddlLoaiDon.SelectedIndex = -1;
            txtDen.Text = "";
            txtNoiDung.Text = "";
            ddlLoaiNgay.SelectedIndex = -1;
            ddlTrangThaiXuLy.SelectedIndex = -1;
            txtTuNgay.Text = string.Empty;
            txtDenNgay.Text = string.Empty;
        }
        
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }
        private void Load_Data()
        {
            DON_CHO_XU_LY_BL obj = new DON_CHO_XU_LY_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            decimal toaan_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable tbl = obj.Get_Don_ChoXuLy(toaan_id, ddlNguonDen.SelectedValue, txtNguoiGuiDon.Text.Trim(), ddlLoaiAn.SelectedValue, txtSoLuongDon.Text.Trim(), ddlLoaiDon.SelectedValue, txtNoiDung.Text.Trim(), txtSoDenTu.Text.Trim(), txtDen.Text.Trim(), ddlLoaiNgay.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), ddlTrangThaiXuLy.SelectedValue, pageindex, page_size);
            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            dgList.PageSize = page_size;
            dgList.DataSource = tbl;
            dgList.DataBind();

            foreach (DataGridItem item in dgList.Items)
            {
                HiddenField ID_DGN = (HiddenField)item.FindControl("hdID_DGN");
                LinkButton tiepNhan = (LinkButton)item.FindControl("lbtTiepNhan");
                LinkButton ghepDon = (LinkButton)item.FindControl("lbtGhepDon");
                decimal ID = Convert.ToDecimal(ID_DGN.Value);
                DON_GUINHAN dgn = dt.DON_GUINHAN.Where(x => x.ID == ID).FirstOrDefault();
                if(dgn.TRANGTHAI == 2 || dgn.TRANGTHAI == 3 || dgn.TRANGTHAI == 4)
                {
                    tiepNhan.Visible = false;
                }
                else
                {
                    tiepNhan.Visible = true;
                }

                if(dgn.TRANGTHAI == 2 || dgn.TRANGTHAI == 3)
                {
                    ghepDon.Visible = false;
                }
                else
                {
                    ghepDon.Visible = true;
                }
            }
        }
        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize2.SelectedValue = dropPageSize.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dropPageSize2_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            //---------------
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                DataRowView dv = (DataRowView)e.Item.DataItem;
                CheckBox chkChon = (CheckBox)e.Item.FindControl("chkTraLai");
                if(dv["TRANGTHAI_MA"].ToString() == "0" || dv["TRANGTHAI_MA"].ToString() == "4")
                {
                    chkChon.Visible = false;
                }
                decimal id_vbdh = Convert.ToDecimal(dv["ID_VBDH"].ToString());
                DON_GUINHAN_LICHSU tb = dt.DON_GUINHAN_LICHSU.Where(x => x.ID_VBDH == id_vbdh).FirstOrDefault();
                LinkButton lblLichSu = (LinkButton)e.Item.FindControl("lblLichSu");
                if (tb == null)
                {
                    lblLichSu.Visible = false;
                }
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal IDVuAn = Convert.ToDecimal(e.CommandArgument.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "ChiTiet":
                    HiddenField hdLoaiDon = (HiddenField)e.Item.FindControl("hdLoaiDon");
                    string loaiDon = hdLoaiDon.Value;
                    string link = "";
                    if (loaiDon == "Đơn khởi kiện")
                    {
                        //Response.Redirect("Popup/ChiTietKK.aspx?ID=" + IDVuAn);
                        link = "/QLAN/DONCHOXULY/Popup/ChiTietKK.aspx?ID=" + IDVuAn;
                    }
                    else if (loaiDon == "Đơn kháng cáo")
                    {
                        link = "/QLAN/DONCHOXULY/Popup/ChiTietKC.aspx?ID=" + IDVuAn;
                    }
                    else
                    {
                        link = "/QLAN/DONCHOXULY/Popup/ChiTietDonKhac.aspx?ID=" + IDVuAn;
                    }
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(950/2); var Mtop = (screen.height/2)-(800/2); javascript:window.open('" + link + "', '_blank', 'height=800px,width=950px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=yes,scrollbars=1'); ", true);
                    break;
                case "GhepDon":
                    HiddenField hdLoaiAn = (HiddenField)e.Item.FindControl("hdLoaiAn");
                    string loaiAn = hdLoaiAn.Value;
                    string linkGD = "";
                    if (loaiAn == "Hình sự")
                    {
                        linkGD = "/QLAN/DONCHOXULY/Popup/pGhepDonAHS.aspx?ID=" + IDVuAn;
                    }
                    else
                    {
                        linkGD = "/QLAN/DONCHOXULY/Popup/pGhepDon.aspx?ID=" + IDVuAn;
                    }
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(1200/2); var Mtop = (screen.height/2)-(950/2); javascript:window.open('" + linkGD + "', '_blank', 'height=950px,width=1200px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=yes,scrollbars=1'); ", true);
                    break;
                //case "TraLai":
                //    string linkTL = "/QLAN/DONCHOXULY/Popup/pTraLai.aspx?ID=" + IDVuAn;
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(760/2);var Mtop = (screen.height/2)-(700/2);window.open( 'your_page.aspx', null, 'height=700,width=760,status=yes,toolbar=no,scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );", true);
                //    break;
                case "LichSu":
                    string linkLS = "/QLAN/DONCHOXULY/Popup/pLichSu.aspx?ID=" + IDVuAn;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(750/2); var Mtop = (screen.height/2)-(300/2); javascript:window.open('" + linkLS + "', '_blank', 'height=300px,width=750px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=no,scrollbars=0'); ", true);
                    break;
                case "TiepNhan":
                    DON_GUINHAN dgn = dt.DON_GUINHAN.Where(x => x.ID == IDVuAn).FirstOrDefault();
                    dgn.TRANGTHAI = 4;
                    dt.SaveChanges();
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Tiếp nhận đơn thành công!')", true);
                    Load_Data();
                    break;
            }
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        #endregion

        protected void cmdTraLai_Click(object sender, EventArgs e)
        {
            if(txtNgayTra.Text == "")
            {
                lbThongbao.Text = "Bạn chưa chọn ngày trả lại!";
                txtNgayTra.Focus();
                return;
            }
            if(txtGhiChu.Text == "")
            {
                lbThongbao.Text = "Bạn chưa nhập ghi chú!";
                txtGhiChu.Focus();
                return;
            }
            int countCheck = 0;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkTraLai");
                if (chkChon.Checked)
                {
                    countCheck++;
                    HiddenField hdID = (HiddenField)Item.FindControl("hdID");
                    decimal DonID = Convert.ToDecimal(hdID.Value);
                    DON_GUINHAN don = dt.DON_GUINHAN.Where(x => x.ID_VBDH == DonID && x.TRANGTHAI != 0).FirstOrDefault();
                    //gọi api don-tra-lai
                    WebClient client = new WebClient();
                    string apiUrl = ConfigurationManager.AppSettings["IpTongDat"] + "don-tra-lai";

                    DateTime tg;
                    bool isCheck = DateTime.TryParse(txtNgayTra.Text, cul, DateTimeStyles.None, out tg);
                    if (!isCheck)
                    {
                        lbThongbao.Text = "Ngày trả lại chưa đúng định dạng!";
                        return;
                    }

                    try
                    {
                        var input = new
                        {
                            idDon = don.ID,
                            idVbdh = don.ID_VBDH,
                            dvNhan = don.DV_NHAN,
                            dvChuyen = don.DV_CHUYEN,
                            thoiGian = tg,
                            nguoiTao = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                            lyDoTraLai = txtGhiChu.Text
                        };
                        string inputJson = JsonConvert.SerializeObject(input);
                        client.Headers.Clear();
                        client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
                        client.Encoding = Encoding.UTF8;
                        string result = client.UploadString(apiUrl, inputJson);
                        JToken jObject = JToken.Parse(result);
                        if ((string)jObject["status"] != "SUCCESS")
                        {
                            lbThongbao.Text = (string)jObject["message"];
                            return;
                        }
                    }
                    catch (Exception ex)
                    {
                        lbThongbao.Text = "Có lỗi xảy ra trong quá trình call API !";
                        return;
                    }

                    //Thêm vào DON_GUINHAN_LICHSU
                    DON_GUINHAN_LICHSU ls = new DON_GUINHAN_LICHSU();
                    ls.ID_VBDH = DonID;
                    ls.THAOTAC = 2;
                    ls.THOIGIAN = DateTime.Parse(this.txtNgayTra.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    ls.LYDOTRA = txtGhiChu.Text;
                    ls.NGAYTAO = DateTime.Now;
                    ls.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.DON_GUINHAN_LICHSU.Add(ls);
                    //Cập nhật lại trạng thái DON_GUINHAN                   
                    don.TRANGTHAI = 0;
                    don.NGAYSUA = DateTime.Now;
                    don.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
            }
            if(countCheck == 0)
            {
                lbThongbao.Text = "Bạn chưa chọn đơn cần trả lại!";
                return;
            }
            lbThongbao.Text = "Trả lại đơn thành công";
            txtNgayTra.Text = txtGhiChu.Text = "";
            Load_Data();
        }
    }
}