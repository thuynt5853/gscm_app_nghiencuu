<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pHisDuongsu.aspx.cs" Inherits="WEB.GSTP.QLAN.AHN.Hoso.Popup.pHisDuongsu" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông tin đương sự</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>

    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
        }

        .box {
            height: 450px;
            overflow: auto;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="box">
                    <div class="box_nd">
                        <div class="truong">
                            <table class="table1">
                              <tr>
                                <td colspan="2">
                                  <asp:Panel runat="server" ID="pndata">
                                    
                                    <asp:DataGrid
                                      ID="dgList"
                                      runat="server"
                                      AutoGenerateColumns="False"
                                      CellPadding="4"
                                      PageSize="20"
                                      AllowPaging="True"
                                      GridLines="None"
                                      PagerStyle-Mode="NumericPages"
                                      CssClass="table2"
                                      HeaderStyle-CssClass="header"
                                      AlternatingItemStyle-CssClass="le"
                                      ItemStyle-CssClass="chan"
                                      Width="100%"
                                      OnItemCommand="dgList_ItemCommand"
                                      OnItemDataBound="dgList_ItemDataBound"
                                    >
                                      <Columns>
                                        <asp:TemplateColumn
                                          HeaderStyle-Width="20px"
                                          ItemStyle-Width="20px"
                                          HeaderStyle-HorizontalAlign="Center"
                                          ItemStyle-HorizontalAlign="Center"
                                        >
                                          <HeaderTemplate> TT </HeaderTemplate>
                                          <ItemTemplate>
                                            <%# Container.DataSetIndex + 1 %>
                                          </ItemTemplate>
                                        </asp:TemplateColumn>
                                         <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                          <HeaderTemplate> Tên người sửa </HeaderTemplate>
                                          <ItemTemplate> <%#Eval("HIS_NGUOISUA") %> </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                          <HeaderTemplate> Tài khoản sửa </HeaderTemplate>
                                          <ItemTemplate> <%#Eval("HIS_TAIKHOANSUA") %> </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                          <HeaderTemplate> Ngày sửa</HeaderTemplate>
                                          <ItemTemplate> <%#Eval("HIS_NGAYSUA") %> </ItemTemplate>
                                        </asp:TemplateColumn>
                                          

                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                          <HeaderTemplate> Tên đương sự </HeaderTemplate>
                                          <ItemTemplate> <%#Eval("TENDUONGSU") %> </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                          <HeaderTemplate> Địa chỉ </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Literal ID="lttDiaChi" runat="server"></asp:Literal>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                      
                                          
                                        <asp:TemplateColumn
                                          HeaderStyle-Width="50px"
                                          HeaderStyle-HorizontalAlign="Center"
                                          ItemStyle-HorizontalAlign="Center"
                                        >
                                          <HeaderTemplate> Đương sự là </HeaderTemplate>
                                          <ItemTemplate> <%#Eval("TENLOAIDS") %> </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn
                                          HeaderStyle-Width="80px"
                                          HeaderStyle-HorizontalAlign="Center"
                                          ItemStyle-HorizontalAlign="Center"
                                        >
                                          <HeaderTemplate> Tư cách tố tụng </HeaderTemplate>
                                           <ItemTemplate>
                                                <asp:Literal ID="lttTuCachToTung" runat="server"></asp:Literal>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn
                                          HeaderStyle-Width="50px"
                                          HeaderStyle-HorizontalAlign="Center"
                                          ItemStyle-HorizontalAlign="Center"
                                        >
                                          <HeaderTemplate> Đại diện </HeaderTemplate>
                                          <ItemTemplate> <%#Eval("DAIDIEN") %> </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn
                                          HeaderStyle-Width="80px"
                                          HeaderStyle-HorizontalAlign="Center"
                                          ItemStyle-HorizontalAlign="Center">
                                          <HeaderTemplate> Trạng thái xác thực </HeaderTemplate>
                                          <ItemTemplate> <%#Eval("TRANGTHAIXACTHUC") %> </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn
                                          DataField="NGUOITAO"
                                          HeaderText="Người tạo"
                                          HeaderStyle-Width="65px"
                                          HeaderStyle-HorizontalAlign="Center"
                                        ></asp:BoundColumn>
                                        <asp:BoundColumn
                                          DataField="NGAYTAO"
                                          HeaderText="Ngày tạo"
                                          HeaderStyle-Width="65px"
                                          HeaderStyle-HorizontalAlign="Center"
                                          DataFormatString="{0:dd/MM/yyyy HH:mm}"
                                        ></asp:BoundColumn>
                                       
                                      </Columns>
                                      <HeaderStyle CssClass="header"></HeaderStyle>
                                      <ItemStyle CssClass="chan"></ItemStyle>
                                      <PagerStyle Visible="false"></PagerStyle>
                                    </asp:DataGrid>
                                    
                                  </asp:Panel>
                                </td>
                              </tr>
                            </table>
                          </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <script type="text/javascript">
            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }
            function Setfocus(controlid) {
                var ctrl = document.getElementById(controlid);
                ctrl.focus();
            }
        </script>
    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
</html>
