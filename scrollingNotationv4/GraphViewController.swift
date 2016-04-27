
import UIKit
import QuartzCore

class GraphViewController: UIViewController, LineChartDelegate {
    
    
    var highScore = 0
    var scores = [CGFloat]()
    var averageScores = [CGFloat]()
    var trailingAverages = [CGFloat]()
    var label = UILabel()
    var lineChart: LineChart!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        for score in appDelegate.allPlayerScores {
            scores.append(CGFloat(score))
            if score > highScore {
                highScore = score
            }
        }
        
        fillAveragesArray()
        fillTrailingAverages()
        var views: [String: AnyObject] = [:]
        
        label.text = "Results"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        views["label"] = label
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: [], metrics: nil, views: views))
        
        // simple arrays
        let data: [CGFloat] = scores
        let data2: [CGFloat] = averageScores
        let data3: [CGFloat] = trailingAverages
        
        // simple line with custom x axis labels
        let xLabels: [String] = [""]
        
        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = false
        lineChart.x.grid.count = 5
        
        if highScore > 0 {
        lineChart.y.grid.count = CGFloat(highScore)
        } else {
            lineChart.y.grid.count = CGFloat(1)
        }
        
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        lineChart.addLine(data2)
        lineChart.addLine(data3)
        self.view.backgroundColor = UIColor.whiteColor()
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        self.view.addSubview(lineChart)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
        
        
        let gamesLabel = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.width / 2) - 50,300,100,20))
        gamesLabel.textAlignment = .Center
        gamesLabel.text = "Games"
        gamesLabel.textColor = UIColor.blackColor()
        gamesLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        self.view.addSubview(gamesLabel)
        
        let scoresLabel = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.width / 2) - 90,350,180,20))
        scoresLabel.textAlignment = .Center
        scoresLabel.text = "•Scores"
        scoresLabel.textColor = UIColor(red: 0.121569, green: 0.466667, blue: 0.705882, alpha: 1)
        self.view.addSubview(scoresLabel)
        
        
        let averageScoresLabel = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.width / 2) - 90,370,180,20))
        averageScoresLabel.textAlignment = .Center
        averageScoresLabel.text = "•Average"
        averageScoresLabel.textColor = UIColor(red: 1, green: 0.498039, blue: 0.054902, alpha: 1)
        self.view.addSubview(averageScoresLabel)
        
        let trailingAverageScoresLabel = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.width / 2) - 90,390,180,20))
        trailingAverageScoresLabel.textAlignment = .Center
        trailingAverageScoresLabel.text = "•Trailing Average (20)"
        trailingAverageScoresLabel.textColor = UIColor(red: 0.172549, green: 0.627451, blue: 0.172549, alpha: 1)
        self.view.addSubview(trailingAverageScoresLabel)
        
    }
    
    func fillAveragesArray() {
        var gameCount:CGFloat = 1
        var scoreCount:CGFloat = 0
        for score in scores {
            scoreCount += CGFloat(score)
            let avg:CGFloat = scoreCount / gameCount
            averageScores.append(avg)
            gameCount++
        }
    }
    
    func fillTrailingAverages() {
        var gameCount:CGFloat = 0
        var scoreCount:CGFloat = 0
        if scores.count > 19 {
            for _ in 0 ..< 19 {
                trailingAverages.append(0)
            }
            
            for i in 19 ..< scores.count {
                scoreCount = 0
                for j in i-19...i {
                    scoreCount += scores[j]
                    gameCount++
                }
                trailingAverages.append(scoreCount / 20)
                scoreCount = 0
            }
        } else {
            for _ in 0 ..< scores.count {
                trailingAverages.append(0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "x: \(x)     y: \(yValues)"
    }
    
    
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    
}

