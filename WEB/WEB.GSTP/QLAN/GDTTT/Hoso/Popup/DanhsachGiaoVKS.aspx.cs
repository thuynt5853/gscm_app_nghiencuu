using BL.GSTP;
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
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.GDTTT.Hoso.Popup
{
    public partial class DanhsachGiaoVKS : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public string GetDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return Convert.ToDateTime(obj).ToString("dd/MM/yyyy");
            }
            catch (Exception ex)
            { return ""; }
        }
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)               
                    Load_Data();
            }
        }
        private DataTable getDS()
        {
            string vARRSELECTID = null;
     
            if (Session[TK_CANHBAO.ARRSELECTID] != null) vARRSELECTID = Session[TK_CANHBAO.ARRSELECTID] + "";
            AHS_VUAN_BL obj = new AHS_VUAN_BL();
           
            DataTable tbl = obj.GetAllPaging_GIAOHS_VKS(vARRSELECTID);
            
            return tbl;
        }
        private void Load_Data()
        {
            DataTable oDT = getDS();
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(oDT.Rows.Count, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> Hồ sơ vụ án trong <b>" + hddTotalPage.Value + "</b> trang";
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
            dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
            dgList.DataSource = oDT;
            dgList.DataBind();
            if (dgList.PageCount <= 1)
            {
                cmdLuuAndClose.Text = "Lưu danh sách";
            }
            else
                cmdLuuAndClose.Text = "Lưu danh sách";
        }

        private void SaveData()
        {
            foreach (DataGridItem item in dgList.Items)
            {
                TextBox txtNgaychuyenVKS = (TextBox)item.FindControl("txtNgaychuyenVKS");
                DropDownList dropCanBo = (DropDownList)item.FindControl("dropCanBo");
                DropDownList dropToaAn_VKS = (DropDownList)item.FindControl("dropToaAn_VKS");
                TextBox txtNguoinhan = (TextBox)item.FindControl("txtNguoinhan");
                TextBox txtGhichu = (TextBox)item.FindControl("txtGhichu");



                string strID = item.Cells[0].Text;
                decimal ID = Convert.ToDecimal(strID);
                string strLOAIAN_ID = item.Cells[1].Text;
                decimal LOAIANID = Convert.ToDecimal(strLOAIAN_ID);

                if (!String.IsNullOrEmpty(txtNgaychuyenVKS.Text.Trim())) {
                    HOSO_PT_BL oBL = new HOSO_PT_BL();
                    
                    // DataTable cHs = oBL.Hoso_PT_List(LOAIANID, ID,1,10);
                    DataTable cHs = oBL.Hoso_PT_List_V2(LOAIANID, ID,1,10);

                    //Kiem tra chua ton tai phieu muon moi lưu
                    if (cHs.Rows.Count == 0)
                    {
                        HOSO_PT oHs = new HOSO_PT();
                        oHs.ID = 0;
                        oHs.LOAIAN = LOAIANID;
                        oHs.VUANID = ID;
                        oHs.LOAI_CN = 1;//Chuyen ho so
                        oHs.CANBOID = Convert.ToDecimal(dropCanBo.SelectedValue);
                        DateTime dNgayChuyen = (String.IsNullOrEmpty(txtNgaychuyenVKS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgaychuyenVKS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        //(String.IsNullOrEmpty(txtNgaychuyenVKS.Text.Trim())) ? DateTime.MinValue : Convert.ToDateTime(txtNgaychuyenVKS.Text.Trim());


                        oHs.NGAY_NC = dNgayChuyen;
                        oHs.DV_GUI_NHAN = Convert.ToDecimal(dropToaAn_VKS.SelectedValue);
                        oHs.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                        oHs.NGUOI_NHAN_VKS = txtNguoinhan.Text.Trim();
                        oHs.GHICHU = txtGhichu.Text.Trim();
                        oHs.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oHs.LOAI_DV = 2;//Vien kiem sat

                        if (oBL.HOSO_PT_INS_UP(oHs) == true)
                        {
                            lbthongbao.Text = "Lưu thành công!";
                            //txtNgaychuyenVKS.Enabled = txtNguoinhan.Enabled = txtGhichu.Enabled = false;
                            txtNgaychuyenVKS.Enabled = txtNguoinhan.Enabled = txtGhichu.Enabled = dropCanBo.Enabled = dropToaAn_VKS.Enabled = false;

                        }
                        
                    }
                }
            }
        }
        protected void cmdLuuAndClose_Click(object sender, EventArgs e)
        {
            SaveData();
            //Response.Write("<script>window.opener.location.reload();</" + "script>");
            //Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
        }
       
        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
           
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                
                try
                { 
                    //Danh muc VKS
                    DropDownList dropToaAn_VKS = (DropDownList)e.Item.FindControl("dropToaAn_VKS");    
                    //load ds VKS
                    List<DM_VKS> lst = dt.DM_VKS.OrderBy(x => x.ARRTHUTU).ToList();
                    dropToaAn_VKS.DataSource = lst;
                    dropToaAn_VKS.DataTextField = "TEN";
                    dropToaAn_VKS.DataValueField = "ID";
                    dropToaAn_VKS.DataBind();
                    
                    
                    dropToaAn_VKS.SelectedValue = Session[ENUM_SESSION.SESSION_DONVIID] + "";
                    // danh muc can bo
                    DropDownList dropCanBo = (DropDownList)e.Item.FindControl("dropCanBo");
                    dropCanBo.Items.Clear();
                    DM_CANBO_BL obj = new DM_CANBO_BL();
                    DataTable tbl = obj.DM_CANBO_QLHS_PT(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        dropCanBo.DataSource = tbl;
                        dropCanBo.DataValueField = "ID";
                        dropCanBo.DataTextField = "HOTEN_STATUS";
                        dropCanBo.DataBind();
                        // dropCanBo.Items.Insert(0, new ListItem("Không chọn", ""));
                    }
                    TextBox txtNgaychuyenVKS = (TextBox)e.Item.FindControl("txtNgaychuyenVKS");
                    TextBox txtNguoinhan = (TextBox)e.Item.FindControl("txtNguoinhan");
                    TextBox txtGhichu = (TextBox)e.Item.FindControl("txtGhichu");
                    DataRowView dv = (DataRowView)e.Item.DataItem;
                    if (dv["NGAYCHUYENVKS"].ToString() + "" != "")
                    {
                        txtNgaychuyenVKS.Enabled = txtNguoinhan.Enabled = txtGhichu.Enabled = dropCanBo.Enabled = dropToaAn_VKS.Enabled = false;
                        dropCanBo.SelectedValue = dv["NGUOIGUI"].ToString();
                        dropToaAn_VKS.SelectedValue = dv["DV_GUI_NHAN"].ToString();
                    }

                }
                catch (Exception ex) { }
            }
        }

    }
}