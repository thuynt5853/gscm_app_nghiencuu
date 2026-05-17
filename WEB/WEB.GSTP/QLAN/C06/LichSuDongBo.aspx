<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LichSuDongBo.aspx.cs" Inherits="WEB.GSTP.QLAN.C06.LichSuDongBo" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Danh sách đơn</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
</head>
<body>
    <style type="text/css">
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: auto;
            overflow-x: auto;
        }

        .Lable_Popup_Add_VV {
            width: 117px;
        }

        .Input_Popup_Add_VV {
            width: 250px;
        }
    </style>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <div class="boxchung">
            <h4 class="tleboxchung">Danh sách bản ghi đã gửi</h4>
            <div class="boder" style="padding: 10px;">                
                <table class="table1">  
                    <tr>
                        <td>
                               <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%">
                                    <Columns>
                                        <%--<asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>--%>
                                        <asp:BoundColumn DataField="DONID" Visible="false"></asp:BoundColumn>                                        
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="LOAI_AN_TEN" HeaderText="Loại án"
                                            HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="center"
                                            HeaderStyle-HorizontalAlign="Center">
                                        </asp:BoundColumn>
                                         <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Mã vụ án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("MavuAn")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>
                                                Thông tin vụ án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <i style='margin-right: 3px;'>Tên vụ việc:</i>  <b><%#Eval("TenVuAn")%></b>                                            
                                                <br />
                                                <i style='margin-right: 3px;'>Cấp xét xử:</i>  <b><%#Eval("CAPXX")%></b>
                                                <br />
                                                <i style='margin-right: 3px;'>Thụ lý:</i>  <b><%#Eval("THULY")%></b>
                                                <br />
                                                <b><i style='margin-right: 3px;'>Nguyễn đơn:</i></b><%#Eval("HO_TEN_NGUYEN_DON")%>
                                                <i style='margin-right: 3px;'> - Ngày sinh:</i><%#Eval("NGAY_SINH_NGUYEN_DON")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Số CCCD:</i><%#Eval("SO_GIAY_TO_NGUYEN_DON")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Địa chỉ:</i><%#Eval("DIACHI_NGUYEN_DON")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Quốc tịch:</i><%#Eval("QUOC_TICH_NGUYEN_DON")%>
                                                <br />
                                                <b><i style='margin-right: 3px;'>Bị đơn:</i></b><%#Eval("HO_TEN_BI_DON")%>                                            
                                                <i style='margin-right: 3px;'> - Ngày sinh:</i><%#Eval("NGAY_SINH_BI_DON")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Số CCCD:</i><%#Eval("SO_GIAY_TO_BI_DON")%>    
                                                <br />
                                                <i style='margin-right: 3px;'>Địa chỉ:</i><%#Eval("DIACHI_BI_DON")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Quốc tịch:</i><%#Eval("QUOC_TICH_BI_DON")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                         <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>
                                                Kết quả giải quyết
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                
                                                <i style='margin-right: 3px;'>Số BA/QD:</i><%#Eval("SO_BAN_AN")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Ngày BA/QD:</i><%#Eval("NGAY_RA_BAN_AN")%>
                                                <br />
                                                <b><i style='margin-right: 3px;'>Ngày hiệu lực:</i></b><%#Eval("NGAY_HIEU_LUC_BA")%>
                                                
                                            </ItemTemplate>
                                        </asp:TemplateColumn>                                        
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tình trạng ly hôn
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#
                                                        Convert.ToInt32(Eval("TRANG_THAI_TTHN")) == 1 ? "Ly hôn" :
                                                        Convert.ToInt32(Eval("TRANG_THAI_TTHN")) == 3 ? "Không công nhận vợ chồng" :
                                                        "" 
                                                        
                                                %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>  
                                         <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tình trạng bản ghi
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Eval("trangThaiBanGhi")%>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>  
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Ghi chú
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Eval("ghiChu")%>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>  
                                        <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                               
                                                <b><%#Eval("TRANGTHAIGUI")%></b>
                                                <br />
                                                <i style='margin-right: 3px;'>Tài khoản gửi:</i><%#Eval("TAIKHOANGUI")%>
                                                <br />
                                                <i style='margin-right: 3px;'>Ngày gửi:</i><%#Eval("NGAYGUI")%>
                                               
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                         <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify" HeaderStyle-Width="90px">
                                            <HeaderTemplate>
                                                Ngày đồng bộ
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div style="width: 90px;">
                                                    <%#Eval("NGAYDONGBO")%>
                                                </div>
                                                
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                </asp:DataGrid>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
       
    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
</html>
