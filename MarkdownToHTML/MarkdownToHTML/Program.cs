using Markdig;
using System;
using System.IO;

namespace MarkdownToHTML
{
	class Program
	{
		static void Main(string[] args)
		{
			if (args.Length != 2)
				throw new ArgumentNullException(nameof(args), "An input and output file are reiqured.");
			String input = args[0];
			String output = args[1];
			if (!File.Exists(input))
				throw new FileNotFoundException();
			MarkdownPipeline markdownPipeline = new MarkdownPipelineBuilder()
				.UseAdvancedExtensions()
				.UseBootstrap()
				.UseFigures()
				.UsePipeTables()
				.UseGridTables()
				.UseTaskLists()
				.UseMediaLinks()
				.UseListExtras()
				.UseFooters()
				.UseDefinitionLists()
				.UseDiagrams()
				.UseCitations()
				.UseSoftlineBreakAsHardlineBreak()
				.Build();
			File.WriteAllText(
				output, 
				Markdown.ToHtml(File.ReadAllText(input), markdownPipeline)
			);
		}
	}
}
